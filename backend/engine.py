# import recsys.algorithm
# from recsys.algorithm.factorize import SVD
from operator import add
from pyspark import SparkContext
from pyspark.sql import SQLContext, Row
from pyspark import SparkConf
from pyspark.mllib.recommendation import ALS
from pyspark.mllib.recommendation import MatrixFactorizationModel 
from pyspark.mllib.recommendation import Rating

# recsys.algorithm.VERBOSE = True

'''
This is the main file which initializes the backend and gets the machine learning algorithms running on spark. Use this file for running.
'''

def get_counts_and_averages(ID_and_ratings_tuple):
    nratings = len(ID_and_ratings_tuple[1])
    return ID_and_ratings_tuple[0],(nratings, float(sum(x for x in ID_and_ratings_tuple[1])) / nratings)

class RecommendationSystem():
    def __init__(self, sc, datapath='./', model='movielens_model'):
        self.sc = sc
        self.start = True
        self.sqlContext = SQLContext(self.sc)

        # self.svd = SVD(filename=datapath+model)
        self.als_model_path = datapath + 'ALS_Model'
        self.als_model = MatrixFactorizationModel.load(sc, self.als_model_path) 
        self.movie_df = self.sqlContext.read.load(datapath +'tables/movies') 
        self.detail_df = self.sqlContext.read.load(datapath +'tables/detail') 
        self.rating_df = self.sqlContext.read.load(datapath +'tables/ratings')

    # call this function to get all recommendations 
    def get_all_recomm(self, userid, moviename):
        # movieid = self.get_movie_id(moviename)

        # all recommendation algorithms return a list of movie ids 
        # recom1 = self.svd_recomm(userid)
        # recom2 = self.svd_similar(movieid)
        recom3 = self.als_new(userid)

        # get info about the movie based on movie ids 
        # brief_info1 = self.get_brief_list(recom1) 
        # brief_info2 = self.get_brief_list(recom2) 
        brief_info3 = self.get_brief_list(recom3)

        # return [brief_info1, brief_info2, brief_info3]
        return [ brief_info3]

    # get movie id based on movie name input 
    def get_movie_id(self, moviename):
        r = self.movie_df.where(self.movie_df['name'].startswith(moviename)).first()

        # return movie id 1 if not found
        if r is None:
            return 1
        return r['movieId']

    # svd recommendation algorithm based on the user's rating history 
    # def svd_recomm(self, userid, only_unknown):
    #     # output format: (movieid, similarity value)
    #     similar_list = self.svd.recommend(userid, n=10, only_unknowns = True, is_row = True)

    #     movieid_list=self.get_id_list(similar_list) 
    #     return movieid_list


    # svd recommendation algorithm based on similar movie 
    # def svd_similar(self, movieid):
    #     similar_list=self.svd.similar(movieid) 
    #     movieid_list=self.get_id_list(similar_list) 
    #     return movieid_list

    # an ALS recommendation algorithm based on user rating history 
    def als_new(self, userid):
        recommended_movies=self.als_model.recommendProducts(userid, 10) 
        recommended_movie_list=[]
        for movie in recommended_movies:
            recommended_movie_list.append(movie[1]) 
        return recommended_movie_list
            
    # return a list of movie id 
    def get_id_list(self, l):
        movieid_list=[] 
        for s in l:
            movieid_list.append(s[0]) 
        return movieid_list

    # get a list of movie info given a list of movie ids 
    def get_brief_list(self, movieList):
        info_list=[]
        for m in movieList:
            info=self.get_brief(m)
            if info['title'] != 'unknown':
                info_list.append(info) 
            if len(info_list) == 5:
                break
        return info_list

    # get movie info (title, direction, genres, rating, cast) 
    def get_brief(self, movieid):
        info={}
        info['movieid']=movieid 
        info['title']= 'unknown' 
        info['genres']= 'unknown' 
        info['rating']=0 
        info['director']= 'unknown' 
        info['cast']= 'unknown'

        m=self.movie_df.where(self.movie_df['movieId'] == movieid).first() 
        if m is not None:
            info['title']=m['name'] 
            info['genres']=m['genres'] 
            if len(info['genres']) > 3:
                info['genres']=info['genres'][0:3]

        d=self.detail_df.where(self.detail_df['movieId'] == movieid).first() 
       
        if d is not None:
            info['director']=d['director'] 
            info['cast']=d['cast']

        r=self.rating_df.where(self.rating_df['movieId'] == movieid)
    

        # default rating to be 4.6 
        if r.count()==0:
            info['rating']=4.6 
        else:
            avg=r.rdd.map(lambda row: row['rating']).reduce(lambda x, y: float(x)+float(y))/r.count()
            info['rating']=avg

        return info

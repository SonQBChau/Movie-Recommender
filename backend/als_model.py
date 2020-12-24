from pyspark import SparkContext
from pyspark.mllib.recommendation import ALS 
from pyspark.mllib.recommendation import Rating

sc = SparkContext("local", "collaborative_filtering")  # initializing sc

# Loading the data using SparkContext
ratings = "./datasets/ratings.csv"
data = sc.textFile(ratings,2000)
header = data.first()  # Get the csv header
# Filter out the csv header
data = data.filter(lambda line: line != header)
ratings_data = data.map(lambda l: l.split(',')) 
ratings = ratings_data.map(lambda l: Rating(int(l[0]), int(l[1]), float(l[2])))

# Building the recommendation model using Alternating Least Squares 
rank = 10
numIterations = 5
model = ALS.train(ratings, rank, numIterations)

# Lets save the model for future use 
model_path = "./ALS_Model" 
model.save(sc,model_path)

import recsys.algorithm
from recsys.algorithm.factorize import SVD  

# SVD Model Computation

# To obtain make the script verbose. 
recsys.algorithm.VERBOSE = True

# Load the ratings file
svd = SVD()
svd.load_data(filename='ratings.csv', sep=',', format={'col': 0, 'row': 1, 'value': 2, 'ids': int})
# Now, lets compute the SVD. 
k = 100 
svd.compute(k=k, min_values=10, pre_normalize=None,mean_center = True, post_normalize = True, savefile ='movielens_model')
print("Model Computed and Created")

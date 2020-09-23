# Movie Recommendation System
Back end app for Movie Recommendation System

### Getting Started

#### Prerequisites
[Anaconda](https://www.anaconda.com/products/individual)

#### Setting up a new environment:
* Python 3.7
* TensorFlow
* Pandas
* NumPy
* Scikit-learn
* Jupyter Notebook

1. Open the Anaconda Navigator and click on Environments.
2. Create a new environment and choose Python 3.7 (rather than 3.8) in order to run TensorFlow.
3. Then, within the new environment, install all of the following packages: tensorflow, numpy, pandas, scikit-learn.
4. Finally, click back on home (still within the Anaconda Navigator) and install Jupyter Notebook

#### Running:
Open the project by launching Jupyter Notebook within the new environment using the Anaconda Navigator.

#### Enable localhost API:
1. Install kernel_gateway. [Read the tutorial](https://ndres.me/post/jupyter-notebook-rest-api/)
2. Run `jupyter kernelgateway --api='kernel_gateway.notebook_http' --seed_uri='project100k.ipynb' --port 9090`
3. Get a public URL so the app can access from [Public URL for localhost](https://tunnelin.com/)
4. Change the public URL `https://xxxx/get_recommended'`. Refer to the frontend readme for this part.

#### Dataset:

You can find the dataset in a separate folder.

The full dataset can be found here:
https://grouplens.org/datasets/movielens/

### Future work:
* System learning over time
* Shorter run time
* Use 1 mil dataset or 27 mil dataset
* Improve recommendation




import os
import re
from pyspark import SparkContext
from pyspark.sql import SQLContext, Row

# Regex used to seperate movie movieId, name, year, and genres
RE = re.compile(
    r'(?P<movieId>\d+), "?(?P<name>.+)\((?P<year>\d+)?"?, (?P<genres>.+)')

# Initialize the Spark context
sc = SparkContext("local", "DataImporter")
# Initialize the SparkSQL context
sqlContext = SQLContext(sc)

# ----Import Movies File----------
# Read in the text file as an RDD
data = sc.textFile('./datasets/movies.csv',2000) #https://stackoverflow.com/questions/26954566/apache-spark-pyspark-crash-for-large-dataset

header = data.first()  # Get the csv header
# Filter out the csv header
data = data.filter(lambda line: line != header) 


# Split the CSV file into rows
# Formatter that takes the CSV line and
# outputs it as a list of datapoints
# Uses a regex with named groups
def formatter_movie(line):
    m = RE.match(line)  # Seperates datapoints
    if (m != None):
        m = m.groupdict()
        movieId = int(m['movieId'])
        name = m['name']
        year = int(m['year'])
        genres = m['genres'].split('|') 
        return [movieId, name, year, genres]




data.map(formatter_movie) # data = data.map(formatter_movie)  does not work
# Filter out rows that dont match
data = data.filter(lambda line: line != None)
# Map the data into a Row data object to prepare it for insertion
movie_data = data.map(lambda l: l.split(',')) 
# rows = movie_data.map(lambda r: Row(movieId=r[0], name=r[1], year=r[2], genres=r[3]))
rows = movie_data.map(lambda r: Row(movieId=r[0], name=r[1], genres=r[2]))
# Create the schema for movies and register a table for it
schemaMovies = sqlContext.createDataFrame(rows)
schemaMovies.registerTempTable("movies")
writer = schemaMovies.write
writer.mode('append').save('tables/movies')




# ----Import Ratings File----------
# Regex used to seperate movie movieId, name, year, and genres
RE = re.compile(
    r'(?P<userId>\d+),(?P<movieId>\d+), (?P<rating>\d\d), (?P<timestamp>\d+)')

# Read in the text file as an RDD
data = sc.textFile('./datasets/ratings.csv', 2000)

header = data.first()  # Get the csv header
# Filter out the csv header
data = data.filter(lambda line: line != header)

# Split the CSV file into rows
def formatter_rating(line):
    m = RE.match(line)  # Seperates datapoints
    if (m != None):
        m = m.groupdict()
        userId = int(m['userId'])
        movieId = int(m['movieId'])
        rating = float(m['rating'])
        timestamp = m['timestamp']
        return [userId, movieId, rating, timestamp]


data.map(formatter_rating) # data = data.map(formatter_rating)  doesn't work
# Filter out rows that dont match
data = data.filter(lambda line: line != None)
rating_data = data.map(lambda l: l.split(',')) 
# Map the data into a Row data object to prepare it for insertion
rows = rating_data.map(lambda r: Row(
    userId=r[0], movieId=r[1], rating=r[2], timestamp=r[3]))
# Create the schema for movies and register a table for it
schemaRatings = sqlContext.createDataFrame(rows)
schemaRatings.registerTempTable("ratings")
writer = schemaRatings.write
writer.mode('append').save('tables/ratings')




# ----Import Details File----------
# Regex used to seperate movie movieId, imdbId, and tmdbId
RE = re.compile(
    r'(?P<movieId>\d+),(?P<imdbId>\d+), (?P<tmdbId>\d+),(?P<director>.+),(?P<cast>.+)')
# Read in the text file as an RDD
data = sc.textFile('./datasets/links_modified.csv', 2000)
header = data.first()  # Get the csv header
# Filter out the csv header
data = data.filter(lambda line: line != header)

#  Split the CSV file into rows
def formatter(line):
    m = RE.match(line)  # Seperates datapoints
    if (m != None):
        m = m.groupdict()
        movieId = int(m['movieId']) 
        imdbId = int(m['imdbId'])
        if m['tmdbId'] != None:
            tmdbId = int(m['tmdbId'])
        else:
            tmdbId = -1
        director = m['director']
        cast = m['cast'].split('|')
        return [movieId, imdbId, tmdbId, director, cast]


data.map(formatter)
# Filter out rows that dont match
data = data.filter(lambda line: line != None)
link_data = data.map(lambda l: l.split(',')) 
# Map the data into a Row data object to prepare it for insertion
rows = link_data.map(lambda r: Row(
    movieId=r[0], imdbId=r[1], tmdbId=r[2], director=r[3], cast=r[4]))
# Create the schema for movies and register a table for it
schemaLinks = sqlContext.createDataFrame(rows) 
schemaLinks.registerTempTable("detail")
writer = schemaLinks.write
writer.mode('append').save('tables/detail')


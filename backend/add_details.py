import imdb
from imdb import IMDb
import csv
import codecs

# Add director and cast info to the links.csv file

# Fetch from IMDB server
# ia = imdb.IMDb(accessSystem='http')
ia = IMDb() 

file_name = './datasets/links.csv'

old = open(file_name, 'rt')
new = codecs.open('links_modified.csv', 'wb', 'utf-8')
reader = csv.reader(old, delimiter=',')
next(reader)

new.write('movieId, imdbId, tmdId, director, cast\n')

for row in reader:
    id = row[1]
    m = ia.get_movie(id)

    director = ''
    cast_list = []
    cast = []

    if m.get('director'):
        director = m.get('director')[0].get('name')

    if m.get('cast'):
        cast_list = m.get('cast')
        l = len(cast_list)
        if l >= 10:
            cast_list = cast_list[0:9]
        else:
            cast_list = cast_list[0:l]

        cast = [c['name'] for c in cast_list]
        cast_elements = '|'.join(cast)
        line = [row[0], id, row[2], director, cast_elements]
        new.write(', '.join(line))
        new.write('\n')
        print(id)

old.close()
new.close()

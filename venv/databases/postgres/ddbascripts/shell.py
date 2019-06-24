import os

os.environ['PATH']='/home/dmitriy/ptvenv'

path = os.getenv('PATH')

if os.path.exists(path):
    os.rmdir(path)
    os.mkdir(path)
else:
    os.mkdir(path)
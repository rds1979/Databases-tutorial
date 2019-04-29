import time
import pymongo
import psycopg2

start = time.time()

def mongo_select(query):
    conn = None
    try:
        conn = pymongo.MongoClient('localhost', 27017)
        base = conn.tutorial
        coll = base.students
        data = coll.find(query)
        postgresql_insert(data)
    except Exception as err:
        print('Ошибка выполнения: ', type(err), err)
    finally:
        if conn is not None:
            conn.close()

def postgresql_insert(data):
    for doc in data:
        print(doc)

if __name__ == '__main__':
    query = {"bdate" : {"$gte" : "ISODate('2000-09-25T00:00:00.000Z')"}}
    #query = {"gender": "Female"}
    mongo_select(query)

print(f"Время выполнения {time.time() - start} секунд ---")
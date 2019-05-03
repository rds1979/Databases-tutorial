import dns
import time
import json
import pymongo
import datetime

start = time.time()

'''Функция получает от вызванной функции "read_json" массив json-записей, который инсертит в MongoDb'''
def mongo_insert(file):
    conn = None
    try:
        #conn = pymongo.MongoClient('localhost', 27017)
        conn = pymongo.MongoClient("mongodb+srv://m001-student:m001-mongodb-basics@sandbox-ip14p.mongodb.net/university?retryWrites=true")
        base = conn.university
        coll = base.students
        data = read_json(file)
        coll.insert_many(data, ordered=False)
    except Exception as err:
        print("Ошибка выполнения: ", type(err), err)
    finally:
        if conn is not None:
            conn.close()

'''Функция принимает на входе json-файл и возвращает вызвавшей функции "mongo_insert" массив данных в формате json'''
def read_json(file):
    with open(file) as json_file:
        data = json.load(json_file)
        for row in data:
            format_date = datetime.datetime.strptime(row['bdate'], "%Y-%m-%d")
            row['bdate'] = format_date
        return data


if __name__ == '__main__':
    file = 'data.json'
    mongo_insert(file)

print(f"Время выполнения {time.time() - start} секунд ---")
import time
import pymongo
import psycopg2

from datetime import date
from config import config

start = time.time()

'''Функция получает от вызванной функции postgre_select массив словарей, который инсертит в MongoDb'''
def mongo_insert(request):
    conn = None
    try:
        conn = pymongo.MongoClient('192.168.0.129', 27017)
        base = conn.currency
        coll = base.currency
        dataset = postgre_select(request)
        coll.insert_many(dataset, ordered=False)
    except Exception as err:
        print("Ошибка выполнения: ", type(err), err)
    finally:
        if conn is not None:
            conn.close()


'''Функция получает массив строк из базы PostgreSQL и передаёт его функции, преобразовывающий массив строк
в массив словарей (preparing_json). Возвращённый массив передаётся вызывающей функции (mongo_insert)'''
def postgre_select(request):
    conn = None
    try:
        params = config()
        conn = psycopg2.connect(**params)
        curr = conn.cursor()
        curr.execute(request)
        response = curr.fetchall()
        dataset = prepearing_json(response)
        return dataset
    except(Exception, psycopg2.DatabaseError) as err:
        print("Ошибка запроса: ", type(err), err)
    finally:
        if conn is not None:
            conn.close()


'''Функция из каждой строки, полученного на вход массива формирует словарь, добавляя его в новый массив,
   преобразовывая массив строк в массив хэшей, который возвращается вызывающей функции (postgre_select)'''
def prepearing_json(response):
    dataset = []
    for string in response:
        valute = {}
        valute['num_code'] = string[1]
        valute['char_code'] = string[2]
        valute['nominal'] = string[3]
        valute['title'] = string[4]
        valute['cost'] = float(string[5])
        valute['date'] = format_date(string[6])
        dataset.append(valute)
    return dataset


'''Функция приводит полученную дату к формату dd.mm.yyyy и возвращает её вызывающей функции (preparing_json)'''
def format_date(received_date = date.today(), separator = '.'):
    format_date = received_date.strftime(f'%d{separator}%m{separator}%Y')
    return format_date


if __name__ == '__main__':
    request = '''SELECT * FROM currency;'''
    mongo_insert(request)

print(f"Время выполнения {time.time() - start} секунд ---")

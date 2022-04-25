import azure.functions as func
import logging
import json
import os
import pymongo
from bson.json_util import dumps


def main(req: func.HttpRequest) -> func.HttpResponse:

    logging.info('Python getPosts trigger function processed a request.')

    try:
        url = os.environ['ConnectionStrings']
        client = pymongo.MongoClient(url)
        database = client['mongodb20220424']
        collection = database['postcollection20220424']
        result = collection.find({})
        result = dumps(result)
        return func.HttpResponse(result, mimetype='application/json',charset='utf-8', status_code=200)
    except Exception as e:
        logging.error(e)   
        return func.HttpResponse("Database connection error.",status_code=400)

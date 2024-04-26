
import json
import math
from collections import defaultdict
from flask import Flask, abort, request
#from flask_basicauth import BasicAuth
#from flask_swagger_ui import get_swaggerui_blueprint
import os
from google.cloud import bigquery

app = Flask(__name__)

MAX_PAGE_SIZE = 10


@app.route("/diamonds/<int:diamond_id>")
# @auth.required
def diamonds(diamond_id):
    client = bigquery.Client(project="da-bootcamp-2023")
    QUERY = f"""SELECT * 
    FROM `Diamonds.diamondss`
    WHERE diamond_id = {diamond_id} """

    query_job = client.query(QUERY)
    rows = query_job.result()

    for row in rows:
        return dict(row.items())
    
    else:
        abort(404)

@app.route("/diamonds")
# @auth.required
def diamondss():
    page = int(request.args.get('page', 1))
    page_size = int(request.args.get('page_size', MAX_PAGE_SIZE))
    page_size = min(page_size, MAX_PAGE_SIZE)

    client = bigquery.Client(project="da-bootcamp-2023")
    QUERY = f"""SELECT * 
    FROM `Diamonds.diamondss`
    ORDER BY diamond_id
    LIMIT {page_size}
    OFFSET {(page-1) * page_size}"""

    query_job = client.query(QUERY)
    rows = query_job.result()
    if not rows:
        abort(404)
    results = []
    for row in rows:
        results.append(dict(row.items()))
    
    return results

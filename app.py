import psycopg2
from elasticsearch import Elasticsearch

# connect to database
pg_conn = {
    "dbname": "nominatim",
    "user": "nominatim",
    'password': "KLL1234",
    "host": "localhost",
    "port": "8888",
}
print('a')
es = Elasticsearch(["http://localhost:9200"])

sql_query = """
    SELECT place_id, rank_search, osm_type, osm_id, class, type, admin_level, name, address, extratags FROM placex;
"""

try:
    # Connect to PostgreSQL
    print('b')
    pg_conn = psycopg2.connect(**pg_conn)
    cursor = pg_conn.cursor()
    print('connected')

    # Execute SQL query
    cursor.execute(sql_query)
    print('c')
    for i, row in enumerate(cursor):
        if i < 10:
            print(row)  # Print the entire row
        else:
            break
    # Index data into Elasticsearch
    for row in cursor:
        name_hstore = row[7]
        if name_hstore is not None:
            cleaned_name = name_hstore.split('=>')[-1].strip('\"')
        else:
            cleaned_name = None
        doc = {
            "place_id": row[0],
            "rank_search": row[1],
            "osm_type": row[2],
            "osm_id": row[3],
            "class": row[4],
            "type": row[5],
            "admin_level": row[6],
            "name": cleaned_name,
            "address": row[8],
            "extratags": row[9],
        }
        # Index document into Elasticsearch
        es.index(index="nominatim_index", body=doc)

    print('d')
except psycopg2.Error as e:
    print("Error connecting to PostgreSQL:", e)

finally:
    # Close connections
    if cursor:
        cursor.close()
    if pg_conn:
        pg_conn.close()

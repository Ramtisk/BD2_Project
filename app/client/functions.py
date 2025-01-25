import os
from django.db import connection
from django.shortcuts import render
import psycopg2


def get_connection():
    try:
        connection = psycopg2.connect(
            dbname=str(os.getenv('POSTGRES_DB')),
            user=str(os.getenv('POSTGRES_USER')),
            password=str(os.getenv('POSTGRES_DB')),
            host="postgres",
            port="5432"
        )
        return connection
    except psycopg2.Error as e:
        print("Erro ao conectar ao banco de dados:", e)
        raise


def get_clientes_recentes():
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT id, username, email, date_joined
            FROM clientes_recentes
        """)
        rows = cursor.fetchall()

    # Transformar os resultados em uma lista de dicionários
    clientes_recentes = [
        {
            'id': row[0],
            'username': row[1],
            'email': row[2],
            'date_joined': row[3]
        }
        for row in rows
    ]

    return clientes_recentes

def contar_clientes():
    with connection.cursor() as cursor:
        cursor.execute("SELECT contar_clientes()")
        result = cursor.fetchone()
    return result[0]

from django.db import connection

def calculate_monthly_profit(month, year):
    with connection.cursor() as cursor:
        cursor.execute("SELECT calculate_monthly_profit(%s, %s)", [month, year])
        result = cursor.fetchone()
    return result[0] if result[0] is not None else 0 

def calculate_total_profit():
    with connection.cursor() as cursor:
        cursor.execute("SELECT calculate_total_profit()")
        result = cursor.fetchone()
    return result[0] if result[0] is not None else 0

from django.db import connection

def get_visitas_tecnicas():
    """
    Busca as visitas técnicas por vir (limite de 10) da view `visitas_tecnicas_por_vir`.
    """
    with connection.cursor() as cursor:
        cursor.execute("SELECT * FROM visitas_tecnicas_por_vir")
        rows = cursor.fetchall()

    # Transformar os resultados em uma lista de dicionários
    visitas = [
        {
            'id': row[0],
            'descricao': row[1],  # Ajuste conforme as colunas da tabela `tecnical_visit`
            'data': row[2],
            'local': row[3],      # Exemplo: 'local' deve ser substituído pela coluna real
        }
        for row in rows
    ]
    return visitas

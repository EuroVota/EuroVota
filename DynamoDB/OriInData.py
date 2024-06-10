import boto3
import time

# Crear una conexión a DynamoDB
dynamodb = boto3.resource('dynamodb', region_name='us-east-1')

# Definir la tabla
table = dynamodb.Table('EurovisionVotes')

# Función para insertar votos
def insert_vote(country, userId, votes):
    response = table.put_item(
       Item={
            'country': country,
            'userId': userId,
            'votes': votes,
            'timestamp': int(time.time())
        }
    )
    return response

# Ejemplo de inserción de votos
insert_vote('Spain', 'user123', 8)
insert_vote('Italy', 'user123', 12)


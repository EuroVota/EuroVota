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
insert_vote('Hungría', '+306945852455', 1)
insert_vote('Finlandia', '+34670920592', 1)
insert_vote('Lituania', '+34688995007', 1)
insert_vote('Spain', '+306945852455', 2)
insert_vote('San Marino', '+34600293137', 1)
insert_vote('Spain', '+34600293137', 2)
insert_vote('Portugal', '+34670920592', 2)
insert_vote('Ucrania', '+34688995007', 2)
insert_vote('Spain', '+306945852455', 3)
insert_vote('Yugoslavia', '+34670920592', 3)
insert_vote('Eslovenia', '+34688995007', 3)
insert_vote('Spain', '+34600293137', 3)
insert_vote('Andorra', '+34670920592', 4)
insert_vote('Bulgaria', '+306945852455', 4)
insert_vote('Spain', '+34688995007', 4)
insert_vote('Bosnia y Herzegovina', '+34600293137', 4)
insert_vote('Spain', '+34688995007', 5)
insert_vote('Moldavia', '+306945852455', 5)
insert_vote('Spain', '+34600293137', 5)
insert_vote('Grecia', '+34670920592', 5)
insert_vote('Suiza', '+306945852455', 6)
insert_vote('Spain', '+34688995007', 6)
insert_vote('Mónaco', '+34600293137', 6)
insert_vote('Spain', '+34688995007', 7)
insert_vote('Montenegro', '+306945852455', 7)
insert_vote('Spain', '+34600293137', 7)
insert_vote('Polonia', '+306945852455', 8)
insert_vote('Spain', '+34688995007', 8)
insert_vote('Turquía', '+34670920592', 6)
insert_vote('Grecia', '+34600293137', 8)
insert_vote('San Marino', '+34670920592', 7)
insert_vote('San Marino', '+34688995007', 9)
insert_vote('Grecia', '+34670920592', 8)
insert_vote('Suiza', '+306945852455', 9)
insert_vote('Spain', '+34600293137', 9)
insert_vote('Mónaco', '+34600293137', 10)
insert_vote('Spain', '+34688995007', 10)
insert_vote('Georgia', '+34670920592', 9)
insert_vote('Montenegro', '+306945852455', 10)
insert_vote('Spain', '+34688995007', 11)
insert_vote('Rusia', '+34670920592', 10)
insert_vote('Polonia', '+306945852455', 11)
insert_vote('Spain', '+34600293137', 11)
insert_vote('Turquía', '+34670920592', 11)
insert_vote('Grecia', '+34600293137', 12)
insert_vote('San Marino', '+34670920592', 12)
insert_vote('San Marino', '+34688995007', 12)
insert_vote('Spain', '+306945852455', 12)

import boto3
from boto3.dynamodb.conditions import Key
from botocore.exceptions import NoCredentialsError, PartialCredentialsError

# Crear una conexión a DynamoDB
dynamodb = boto3.resource('dynamodb', region_name='us-east-1')

# Definir la tabla
table = dynamodb.Table('EurovisionVotes')

# Función para obtener votaciones de un usuario
def get_votes_by_user(userId):
    try:
        response = table.query(
            IndexName='userId-country-index',  # Asegúrate de tener un índice secundario global (GSI) en userId
            KeyConditionExpression=Key('userId').eq(userId)
        )
        return response['Items']
    except NoCredentialsError:
        print("Error: No se encontraron las credenciales de AWS.")
    except PartialCredentialsError:
        print("Error: Credenciales incompletas de AWS.")
    except Exception as e:
        print(f"Error al obtener votaciones del usuario: {e}")

# Función para obtener votos totales a un país
def get_total_votes_by_country(country):
    try:
        response = table.query(
            KeyConditionExpression=Key('country').eq(country)
        )
        total_votes = sum(item['votes'] for item in response['Items'])
        return total_votes
    except NoCredentialsError:
        print("Error: No se encontraron las credenciales de AWS.")
    except PartialCredentialsError:
        print("Error: Credenciales incompletas de AWS.")
    except Exception as e:
        print(f"Error al obtener votos totales del país: {e}")

# Función para obtener el ranking de los mejores países
def get_ranking():
    try:
        response = table.scan()
        country_votes = {}
        for item in response['Items']:
            country = item['country']
            votes = item['votes']
            if country in country_votes:
                country_votes[country] += votes
            else:
                country_votes[country] = votes
        sorted_countries = sorted(country_votes.items(), key=lambda x: x[1], reverse=True)
        return sorted_countries
    except NoCredentialsError:
        print("Error: No se encontraron las credenciales de AWS.")
    except PartialCredentialsError:
        print("Error: Credenciales incompletas de AWS.")
    except Exception as e:
        print(f"Error al obtener el ranking: {e}")

# Ejemplo de uso
user_votes = get_votes_by_user('+34688995007')
print("Votaciones del usuario +34688995007:", user_votes)

total_votes_spain = get_total_votes_by_country('Spain')
print("Votos totales para España:", total_votes_spain)

ranking = get_ranking()
print("Ranking de los mejores países:", ranking)

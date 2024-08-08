#Configuración

#Tabla DynamoDB (aws_dynamodb_table.eurovision_votes): Se ha configurado para incluir los campos userId, country, voteValue, voteId y timestamp. Se han definido dos índices globales secundarios (GSI):
##country-voteValue-index: Para obtener el sumatorio de voteValue por country.
##userId-timestamp-index: Para obtener las entradas realizadas por userId.
#Autoescalado: Se han configurado objetivos y políticas de autoescalado para las capacidades de lectura y escritura de la tabla DynamoDB, para asegurar que la tabla pueda manejar los picos de demanda durante las votaciones.

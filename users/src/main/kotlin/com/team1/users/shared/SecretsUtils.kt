package com.team1.users.shared

import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.secretsmanager.SecretsManagerClient
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueRequest
import software.amazon.awssdk.services.secretsmanager.model.GetSecretValueResponse


@Suppress("UNCHECKED_CAST")
@Configuration
class SecretsUtils {

  @Value("\${app.aws.secrets.name}")
  lateinit var secretName: String

  @Value("\${app.aws.region}")
  lateinit var region: String

  @Bean
  fun secretsManagerClient(): SecretsManagerClient = SecretsManagerClient.builder()
    .region(Region.of(region))
    .build()

  @Bean
  fun getSecrets(): Map<String, String> {

    val objectMapper = ObjectMapper()

    val getSecretValueRequest = GetSecretValueRequest.builder()
      .secretId(secretName)
      .build()


    val getSecretValueResponse: GetSecretValueResponse

    try {
      getSecretValueResponse = this.secretsManagerClient().getSecretValue(getSecretValueRequest)
    } catch (e: Exception) {
      // For a list of exceptions thrown, see https://docs.aws.amazon.com/secretsmanager/latest/apireference/API_GetSecretValue.html
      throw e
    }

    val secret = getSecretValueResponse.secretString()
    return objectMapper.readValue(secret, Map::class.java) as Map<String, String>
  }


}
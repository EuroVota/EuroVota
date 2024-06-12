package com.team1.users.shared

import com.team1.users.session.infrastructure.repository.SessionCognitoRepository
import com.team1.users.user.infrastructure.repository.cognito.AwsCognitoRepository
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.cognitoidentityprovider.CognitoIdentityProviderClient

@Configuration
class DataBaseConfig {

  @Value("\${app.aws.region}")
  lateinit var region: String


  @Bean
  fun cognitoClient(): CognitoIdentityProviderClient = CognitoIdentityProviderClient
    .builder()
    .region(Region.of(region))
    .build()

  @Bean
  fun userRepository(cognitoClient: CognitoIdentityProviderClient) = AwsCognitoRepository(cognitoClient)
  @Bean
  fun sessionUserRepository(cognitoClient: CognitoIdentityProviderClient) = SessionCognitoRepository(cognitoClient)


}
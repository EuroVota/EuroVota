package com.team1.users.utils

import com.auth0.jwt.JWT
import com.auth0.jwt.JWTVerifier
import com.auth0.jwt.algorithms.Algorithm
import com.auth0.jwt.interfaces.RSAKeyProvider
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
class JwtDecoder {

  @Value("\${app.aws.cognito.poolId}")
  lateinit var poolId: String

  @Value("\${app.aws.region}")
  lateinit var region: String

  @Bean
  fun keyProvider(): RSAKeyProvider = AwsCognitoRSAKeyProvider(region, poolId)

  @Bean
  fun algorithm(keyProvider: RSAKeyProvider): Algorithm = Algorithm.RSA256(keyProvider)

  @Bean
  fun getJwtVerifier(algorithm: Algorithm): JWTVerifier = JWT
    .require(algorithm)
    .build()

}
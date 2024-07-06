package com.team1.votes.utils

import com.auth0.jwt.JWT
import com.auth0.jwt.JWTVerifier
import com.auth0.jwt.algorithms.Algorithm
import com.auth0.jwt.interfaces.Claim
import com.auth0.jwt.interfaces.RSAKeyProvider
import com.team1.votes.shared.exception.UnauthorizedException
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

  fun getUserId(jwtVerifier: JWTVerifier, bearerToken: String): String {
    val token = getToken(bearerToken)

    try {
      val decodedJWT = jwtVerifier.verify(token)
      val subject = decodedJWT.subject
      return subject
    } catch (e: Exception) {
      throw UnauthorizedException()
    }
  }

  fun getClaims(jwtVerifier: JWTVerifier, bearerToken: String): Map<String, Claim> {
    val token = getToken(bearerToken)

    try {
      val decodedJWT = jwtVerifier.verify(token)
      val claims = decodedJWT.claims
      return claims
    } catch (e: Exception) {
      throw UnauthorizedException()
    }
  }

  private fun getToken(bearerToken: String) : String {
    return bearerToken
      .let {
        if (!it.startsWith("Bearer ")) {
          throw UnauthorizedException()
        }
        it.substring(7)
      }
  }

}
package com.team1.users.session.infrastructure.repository

import com.team1.users.session.domain.SessionRepository
import com.team1.users.session.infrastructure.repository.dto.TokenDTO
import com.team1.users.shared.SecretsUtils
import com.team1.users.user.domain.*
import org.springframework.beans.factory.annotation.Value
import software.amazon.awssdk.services.cognitoidentityprovider.CognitoIdentityProviderClient
import software.amazon.awssdk.services.cognitoidentityprovider.model.*

class SessionCognitoRepository(
  private val cognitoClient: CognitoIdentityProviderClient,
  secretsUtils: SecretsUtils) : SessionRepository {


  private val clientId: String = secretsUtils.getSecrets()["CLIENT_ID"] ?: throw IllegalStateException("Client ID not found")

  override fun login(userPhone: UserPhone, userPassword: UserPassword): TokenDTO {

    // To build the authentication request
    val authRequest = InitiateAuthRequest
      .builder()
      .clientId(clientId)
      .authFlow(AuthFlowType.USER_PASSWORD_AUTH)
      .authParameters(
        mapOf(
          "USERNAME" to userPhone.value,
          "PASSWORD" to userPassword.value
        )
      )
      .build()

    // To do the authentication request
    val authResponse = cognitoClient.initiateAuth(authRequest)

    // Check if the authentication result is not null
    val authResult = authResponse.authenticationResult()

    // Obtain the tokens from the response
    val accessToken = authResult.accessToken()
    val refreshToken = authResult.refreshToken()
    val idToken = authResult.idToken()

    return TokenDTO(accessToken, refreshToken, idToken)

  }
}
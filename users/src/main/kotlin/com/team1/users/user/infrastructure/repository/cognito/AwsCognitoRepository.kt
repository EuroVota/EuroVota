package com.team1.users.user.infrastructure.repository.cognito

import com.team1.users.session.infrastructure.repository.dto.TokenDTO
import com.team1.users.user.domain.*
import org.springframework.beans.factory.annotation.Value
import software.amazon.awssdk.services.cognitoidentityprovider.CognitoIdentityProviderClient
import software.amazon.awssdk.services.cognitoidentityprovider.model.*
import java.time.Instant

class AwsCognitoRepository(private val cognitoClient: CognitoIdentityProviderClient) : UserRepository {


  @Value("\${app.aws.cognito.clientId}")
  lateinit var clientId: String

  @Value("\${app.aws.cognito.poolId}")
  lateinit var poolId: String

  override fun register(userPhone: UserPhone, userPassword: UserPassword): UserId {

    // To build the authentication request
    val signUpRequest = SignUpRequest
      .builder()
      .clientId(clientId)
      .userAttributes(
        listOf(
          AttributeType
            .builder()
            .name("phone_number")
            .value(userPhone.value)
            .build()
        )
      )
      .username(userPhone.value)
      .password(userPassword.value)
      .build()


    // To do the authentication request
    val signUpResponse = cognitoClient.signUp(signUpRequest)

    return UserId.fromString(signUpResponse.userSub())


  }

  override fun findById(id: UserId): User? {

    val getUserRequest = AdminGetUserRequest
      .builder()
      .userPoolId(poolId)
      .username(id.value.toString())
      .build()

    return getUser(getUserRequest)
  }


  override fun findByPhone(phone: UserPhone): User? {
    val getUserRequest = AdminGetUserRequest
      .builder()
      .userPoolId(poolId)
      .username(phone.value)
      .build()

    return getUser(getUserRequest)
  }


  private fun getUser(getUserRequest: AdminGetUserRequest?) : User? {
    return cognitoClient
      .adminGetUser(getUserRequest)
      .let {

        it
          .userAttributes()
          .let { userAttributes ->
            if (userAttributes.isEmpty()) {
              null
            } else {
              User
                .create(
                  userAttributes.find { attributeType ->  attributeType.name() == "sub" }?.value()?.let { value -> UserId.fromString(value) }
                    ?: throw IllegalStateException("User corrupted"),
                  userAttributes.find { attributeType ->  attributeType.name() == "phone_number" }?.value()?.let {value -> UserPhone(value) }
                    ?: throw IllegalStateException("User corrupted"),
                  userAttributes.find { attributeType ->  attributeType.name() == "phone_number_verified" }?.value()?.let {value ->  value.toBoolean() }
                    ?: throw IllegalStateException("User corrupted"),
                  it.userCreateDate(),
                  it.userLastModifiedDate(),
                  UserStatus(it.userStatus().name)
                )
            }
          }
      }
  }

  override fun validate(userPhone: UserPhone, validationCode: Int) {


    val confirmSignUpRequest = ConfirmSignUpRequest
      .builder()
      .clientId(clientId)
      .username(userPhone.value)
      .confirmationCode(validationCode.toString())
      .build()

    cognitoClient.confirmSignUp(confirmSignUpRequest)

  }
}
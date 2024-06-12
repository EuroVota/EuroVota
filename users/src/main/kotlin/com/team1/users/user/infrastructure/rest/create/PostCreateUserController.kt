package com.team1.users.user.infrastructure.rest.create

import com.team1.users.user.application.UserCreateUseCase
import com.team1.users.user.application.exception.UserPhoneAlreadyExistsException
import com.team1.users.user.domain.InvalidUserPasswordException
import com.team1.users.user.domain.InvalidUserPhoneException
import com.team1.users.user.domain.UserPassword
import com.team1.users.user.domain.UserPhone
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.cognitoidentityprovider.CognitoIdentityProviderClient
import software.amazon.awssdk.services.cognitoidentityprovider.model.*
import java.net.URI

@RestController
class PostCreateUserController(private val userCreateUseCase: UserCreateUseCase) {

  @PostMapping("/users")
  fun execute(
    @RequestBody request: CreateUserRequest
  ): ResponseEntity<String> {

    return try {
      val userId = userCreateUseCase
        .create(
          UserPhone(request.phone),
          UserPassword(request.password)
        )

      ResponseEntity.created(URI.create("/v1/users/${userId.value}")).build()

    } catch (exception: Throwable) {
      when (exception) {
        is InvalidUserPhoneException -> ResponseEntity
          .status(HttpStatus.BAD_REQUEST)
          .body(exception.message)

        is InvalidUserPasswordException -> ResponseEntity
          .status(HttpStatus.BAD_REQUEST)
          .body(exception.message)

        is CognitoIdentityProviderException -> ResponseEntity
          .status(HttpStatus.CONFLICT)
          .body(exception.message)

        else -> ResponseEntity
          .status(HttpStatus.INTERNAL_SERVER_ERROR)
          .body(exception.message.toString())

      }
    }

  }

}


data class CreateUserRequest(
  val phone: String = "",
  val password: String = ""
)
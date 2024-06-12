package com.team1.users.user.infrastructure.rest.validate

import com.team1.users.user.application.UserValidateUseCase
import com.team1.users.user.domain.InvalidUserPhoneException
import com.team1.users.user.domain.UserPhone
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PatchMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import software.amazon.awssdk.services.cognitoidentityprovider.model.CognitoIdentityProviderException
import software.amazon.awssdk.services.cognitoidentityprovider.model.ExpiredCodeException

@RestController
class UserValidateController(private val userValidateUseCase: UserValidateUseCase) {

  @PatchMapping("/users/validate")
  fun validate(
    @RequestBody request: ValidateUserRequest
  ): ResponseEntity<String> {

    return try {
      userValidateUseCase
        .validate(
          UserPhone(request.phone),
          request.code
        )

      ResponseEntity
        .status(HttpStatus.NO_CONTENT)
        .build()
    } catch (exception: Throwable) {
      when (exception) {

        is InvalidUserPhoneException -> ResponseEntity
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

data class ValidateUserRequest(
  val phone: String = "",
  val code: Int = 0
)

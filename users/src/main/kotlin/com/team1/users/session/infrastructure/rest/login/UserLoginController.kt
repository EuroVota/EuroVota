package com.team1.users.session.infrastructure.rest.login

import com.google.gson.Gson
import com.team1.users.user.application.UserLoginUseCase
import com.team1.users.user.domain.InvalidUserPasswordException
import com.team1.users.user.domain.InvalidUserPhoneException
import com.team1.users.user.domain.UserPassword
import com.team1.users.user.domain.UserPhone
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpStatus
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import software.amazon.awssdk.services.cognitoidentityprovider.model.CognitoIdentityProviderException

@RestController
class UserLoginController(private val userLoginUseCase: UserLoginUseCase, private val gson: Gson) {

  @PostMapping("/login")
  fun login(
    @RequestBody request: ValidateUserRequest
  ): ResponseEntity<String> {

    return try {
      val tokenDTO = userLoginUseCase
        .login(UserPhone(request.phone), UserPassword(request.password))


      val headers = HttpHeaders()
      headers.contentType = MediaType.APPLICATION_JSON

      ResponseEntity
        .status(HttpStatus.OK)
        .headers(headers)
        .body(gson.toJson(tokenDTO))

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
          .internalServerError()
          .build()

      }
    }


  }
}

data class ValidateUserRequest(
  val phone: String = "",
  val password: String = ""
)

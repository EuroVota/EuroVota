package com.team1.users.user.infrastructure.rest.get

import com.google.gson.Gson
import com.team1.users.user.application.UserGetUseCase
import com.team1.users.user.domain.*
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpStatus
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RestController
import software.amazon.awssdk.services.cognitoidentityprovider.model.CognitoIdentityProviderException

@RestController
class UserGetController(private val userGetUseCase: UserGetUseCase, private val gson: Gson) {

  @GetMapping("/users/{phone}")
  fun getByPhone(
    @PathVariable phone: String
  ): ResponseEntity<String> {

    return try {

      val user = userGetUseCase
        .getByPhone(UserPhone(phone))

      val headers = HttpHeaders()
      headers.contentType = MediaType.APPLICATION_JSON

      ResponseEntity
        .status(HttpStatus.OK)
        .headers(headers)
        .body(gson.toJson(user.mapValues()))

    } catch (exception: Throwable) {
      when (exception) {
        is InvalidUserPhoneException -> ResponseEntity
          .status(HttpStatus.BAD_REQUEST)
          .body(exception.message)

        is CognitoIdentityProviderException -> ResponseEntity
          .status(HttpStatus.CONFLICT)
          .body(exception.message)

        else -> ResponseEntity
          .internalServerError()
          .body(exception.message)


      }
    }

  }

  @GetMapping("/users/id/{userId}")
  fun getById(
    @PathVariable userId: String
  ): ResponseEntity<String> {

    return try {

      val user = userGetUseCase
        .getById(UserId.fromString(userId))

      val headers = HttpHeaders()
      headers.contentType = MediaType.APPLICATION_JSON

      ResponseEntity
        .status(HttpStatus.OK)
        .headers(headers)
        .body(gson.toJson(user.mapValues()))

    } catch (exception: Throwable) {
      when (exception) {
        is InvalidUserPhoneException -> ResponseEntity
          .status(HttpStatus.BAD_REQUEST)
          .body(exception.message)

        is CognitoIdentityProviderException -> ResponseEntity
          .status(HttpStatus.CONFLICT)
          .body(exception.message)

        else -> ResponseEntity
          .internalServerError()
          .body(exception.message)

      }
    }

  }
}

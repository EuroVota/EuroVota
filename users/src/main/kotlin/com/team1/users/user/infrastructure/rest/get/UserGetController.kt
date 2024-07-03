package com.team1.users.user.infrastructure.rest.get

import com.auth0.jwt.JWT
import com.auth0.jwt.JWTVerifier
import com.auth0.jwt.algorithms.Algorithm
import com.auth0.jwt.interfaces.RSAKeyProvider
import com.google.gson.Gson
import com.team1.users.user.application.UserGetUseCase
import com.team1.users.user.application.exception.UnauthorizedException
import com.team1.users.user.domain.*
import com.team1.users.utils.AwsCognitoRSAKeyProvider
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpStatus
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RestController
import software.amazon.awssdk.services.cognitoidentityprovider.model.CognitoIdentityProviderException

@RestController
class UserGetController(private val userGetUseCase: UserGetUseCase, private val gson: Gson) {

  @GetMapping("/users/{phone}")
  fun getByPhone(
    @PathVariable phone: String,
    @RequestHeader ("Authorization") bearerToken: String
  ): ResponseEntity<String> {

    return try {

      val user = userGetUseCase
        .getByPhone(UserPhone(phone), bearerToken)

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

        is UnauthorizedException -> ResponseEntity
          .status(HttpStatus.UNAUTHORIZED)
          .body(exception.message)

        else -> ResponseEntity
          .internalServerError()
          .body(exception.message)


      }
    }

  }

  @GetMapping("/users/id/{userId}")
  fun getById(
    @PathVariable userId: String,
    @RequestHeader ("Authorization") bearerToken: String
  ): ResponseEntity<String> {

    return try {

      val user = userGetUseCase
        .getById(UserId.fromString(userId), bearerToken)

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

        is UnauthorizedException -> ResponseEntity
          .status(HttpStatus.UNAUTHORIZED)
          .body(exception.message)

        else -> ResponseEntity
          .internalServerError()
          .body(exception.message)

      }
    }

  }
}

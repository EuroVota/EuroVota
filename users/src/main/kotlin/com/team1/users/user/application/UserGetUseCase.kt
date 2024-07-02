package com.team1.users.user.application

import com.auth0.jwt.JWTVerifier
import com.team1.users.user.application.exception.UnauthorizedException
import com.team1.users.user.application.exception.UserNotFoundByPhoneException
import com.team1.users.user.application.exception.UserNotFoundException
import com.team1.users.user.domain.User
import com.team1.users.user.domain.UserId
import com.team1.users.user.domain.UserPhone
import com.team1.users.user.domain.UserRepository


class UserGetUseCase(
  private val userRepository: UserRepository,
  private val jwtVerifier: JWTVerifier
) {

  fun getByPhone(phone: UserPhone, bearerToken: String): User {

    val subject = getUserId(bearerToken)

    return userRepository
      .findByPhone(phone)
      .let {
        it ?: throw UserNotFoundByPhoneException(phone.value)
        if (it.id.value.toString() != subject) {
          throw UserNotFoundException(it.id.value.toString())
        }
        it
      }

  }

  private fun getUserId(bearerToken: String): String? {
    val token = bearerToken
      .let {
        if (!it.startsWith("Bearer ")) {
          throw UnauthorizedException()
        }
        it.substring(7)
      }

    try {
      val decodedJWT = jwtVerifier.verify(token)
      val subject = decodedJWT.subject
      return subject
    } catch (e: Exception) {
      throw UnauthorizedException()
    }
  }

  fun getById(id: UserId, bearerToken: String): User {

    val subject = this.getUserId(bearerToken)

    return userRepository
      .findById(id)
      .let {
        it ?: throw UserNotFoundException(id.value.toString())
        if (it.id.value.toString() != subject) {
          throw UserNotFoundException(it.id.value.toString())
        }
        it
      }

  }


}
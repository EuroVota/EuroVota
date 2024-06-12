package com.team1.users.user.application

import com.team1.users.user.application.exception.UserNotFoundByPhoneException
import com.team1.users.user.application.exception.UserNotFoundException
import com.team1.users.user.domain.User
import com.team1.users.user.domain.UserId
import com.team1.users.user.domain.UserPhone
import com.team1.users.user.domain.UserRepository

class UserGetUseCase(
  private val userRepository: UserRepository
) {

  fun getByPhone(phone: UserPhone): User {

    return userRepository
      .findByPhone(phone)
      .let {
        it ?: throw UserNotFoundByPhoneException(phone.value)
      }

  }

  fun getById(id: UserId): User {

    return userRepository
      .findById(id)
      .let {
        it ?: throw UserNotFoundException(id.value.toString())
      }

  }


}
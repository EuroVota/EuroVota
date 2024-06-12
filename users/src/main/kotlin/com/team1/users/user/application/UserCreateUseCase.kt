package com.team1.users.user.application

import com.team1.users.user.domain.*

class UserCreateUseCase(
  private val userRepository: UserRepository
) {


  fun create(phone: UserPhone, password: UserPassword): UserId {

    return userRepository.register(phone, password)

  }


}
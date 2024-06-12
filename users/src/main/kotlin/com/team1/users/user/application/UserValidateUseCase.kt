package com.team1.users.user.application

import com.team1.users.user.domain.UserPhone
import com.team1.users.user.domain.UserRepository

class UserValidateUseCase(
  private val userRepository: UserRepository
) {

  fun validate(phone: UserPhone, validationCode: Int) {

    userRepository.validate(phone, validationCode)

  }


}
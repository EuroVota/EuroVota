package com.team1.users.user.application

import com.team1.users.session.infrastructure.repository.SessionCognitoRepository
import com.team1.users.user.domain.UserPassword
import com.team1.users.user.domain.UserPhone
import com.team1.users.user.domain.UserRepository
import com.team1.users.session.infrastructure.repository.dto.TokenDTO

class UserLoginUseCase(
  private val sessionCognitoRepository: SessionCognitoRepository
) {

  fun login(phone: UserPhone, password: UserPassword): TokenDTO {

    return sessionCognitoRepository.login(phone, password)

  }


}
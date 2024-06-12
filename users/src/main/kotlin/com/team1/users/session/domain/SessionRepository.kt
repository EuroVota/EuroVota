package com.team1.users.session.domain

import com.team1.users.session.infrastructure.repository.dto.TokenDTO
import com.team1.users.user.domain.UserPassword
import com.team1.users.user.domain.UserPhone

interface SessionRepository {


  fun login(userPhone: UserPhone, userPassword: UserPassword): TokenDTO
}
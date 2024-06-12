package com.team1.users.user.domain

interface UserRepository {

  fun register(userPhone: UserPhone, userPassword: UserPassword): UserId

  fun findById(id: UserId): User?

  fun findByPhone(phone: UserPhone): User?

  fun validate(userPhone: UserPhone, validationCode: Int)
}
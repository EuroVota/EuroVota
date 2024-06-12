package com.team1.users.user.domain

import java.time.Instant
import java.util.*
import java.util.regex.Pattern

data class User(
  var id: UserId,
  val phone: UserPhone,
  val verified: Boolean,
  val createdAt: Instant,
  val updatedAt: Instant,
  val status: UserStatus
) {

  companion object {

    fun create(
      id: UserId,
      phone: UserPhone,
      verified: Boolean,
      createdAt: Instant,
      updatedAt: Instant,
      status: UserStatus
    ): User {

      return User(
        id,
        phone,
        verified,
        createdAt,
        updatedAt,
        status
      )

    }
  }

  fun mapValues(): Map<String, Any> {
    return mapOf(
      "id" to id.value,
      "phone" to phone.value,
      "verified" to verified,
      "createdAt" to createdAt,
      "updatedAt" to updatedAt,
      "status" to status.value
    )
  }

}

data class UserStatus(val value: String) {

}

data class UserId(val value: UUID) {

  companion object {
    fun fromString(id: String) = try {
      UserId(UUID.fromString(id))
    } catch (exception: Exception) {
      throw InvalidUserIdException(id, exception)
    }
  }

}

data class UserPhone(val value: String) {

  init {
    validate()
  }

  private fun validate() {
    val stringPattern = "^\\+\\d{5,15}\$"
    val pattern = Pattern.compile(stringPattern)

    val matcher = pattern.matcher(value)

    if (!matcher.matches()) {
      throw InvalidUserPhoneException(value)
    }
  }

}

data class UserPassword(val value: String) {

  init {
    validate()
  }

  private fun validate() {
    val stringPattern = "^(?=.*[A-Z])(?=.*\\d)(?=.*[@\$!%*?&])[A-Za-z\\d@\$!%*?&]{8,}\$"
    val pattern = Pattern.compile(stringPattern)

    val matcher = pattern.matcher(value)

    if (!matcher.matches()) {
      throw InvalidUserPasswordException(value)
    }
  }

}



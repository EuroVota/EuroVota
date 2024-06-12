package com.team1.users.user.domain

sealed class UserException (override val message: String, override val cause: Throwable? = null) : RuntimeException(message, cause)

data class InvalidUserIdException(val id: String, override val cause: Throwable?) : UserException("The id <$id> is not a valid user id", cause)
data class InvalidUserPhoneException(val phone: String) : UserException("The email <$phone> is not a valid phone number")
data class InvalidUserPasswordException(val password: String) : UserException("The password <$password> is not a valid password format")

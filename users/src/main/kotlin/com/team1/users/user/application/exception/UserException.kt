package com.team1.users.user.application.exception

sealed class UserException (override val message: String, override val cause: Throwable? = null) : RuntimeException(message, cause)

data class UserNotFoundException(val id: String) : UserException("The user <$id> not found")
data class UserNotFoundByPhoneException(val phone: String) : UserException("The user not found with phone: <$phone>")
data class UserPhoneAlreadyExistsException(val phone: String) : UserException("The user <$phone> already exists")

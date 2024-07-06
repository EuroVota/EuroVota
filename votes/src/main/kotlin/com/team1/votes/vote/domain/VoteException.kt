package com.team1.votes.vote.domain

sealed class VoteException (override val message: String, override val cause: Throwable? = null) : RuntimeException(message, cause)

data class InvalidVoteIdException(val id: String, override val cause: Throwable?) : VoteException("The id <$id> is not a valid vote id", cause)
data class InvalidUserIdException(val id: String, override val cause: Throwable?) : VoteException("The id <$id> is not a valid user id", cause)
data class InvalidVotePhoneException(val phone: String) : VoteException("The email <$phone> is not a valid phone number")
data class InvalidVotePasswordException(val password: String) : VoteException("The password <$password> is not a valid password format")

package com.team1.votes.vote.application.exception

sealed class VoteApplicationException (override val message: String, override val cause: Throwable? = null) : RuntimeException(message, cause)

class VoteLimitException : VoteApplicationException("The user has already voted 5 times")
class InvalidPhoneNumberException : VoteApplicationException("Invalid phone number")
class CountryNotFoundException : VoteApplicationException("Country not found")
class CountryInvalidException : VoteApplicationException("Country invalid")


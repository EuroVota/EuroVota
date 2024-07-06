package com.team1.votes.shared.exception

sealed class HttpException (override val message: String, override val cause: Throwable? = null) : RuntimeException(message, cause)

class UnauthorizedException : HttpException("Unauthorized")

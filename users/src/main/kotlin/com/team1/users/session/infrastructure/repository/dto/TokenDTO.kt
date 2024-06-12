package com.team1.users.session.infrastructure.repository.dto

data class TokenDTO(
  val accessToken: String,
  val refreshToken: String,
  val idToken: String
)
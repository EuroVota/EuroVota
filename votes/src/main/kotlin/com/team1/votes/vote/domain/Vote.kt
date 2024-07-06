package com.team1.votes.vote.domain

import java.time.Instant
import java.util.*

data class Vote(
  val id: VoteId,
  val userId: UserId,
  val countryName: CountryName,
  val createdAt: Instant,
  val voteValue: VoteValue
) {

  companion object {
    fun create(
      userId: UserId,
      countryName: CountryName,
      voteValue: VoteValue
    ): Vote {
      return Vote(
        VoteId(UUID.randomUUID()),
        userId,
        countryName,
        Instant.now(),
        voteValue
      )
    }
  }
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

data class VoteId(val value: UUID) {

  companion object {
    fun fromString(id: String) = try {
      VoteId(UUID.fromString(id))
    } catch (exception: Exception) {
      throw InvalidVoteIdException(id, exception)
    }
  }

}

data class CountryName(val value: String)

data class VoteValue(val value: Int)


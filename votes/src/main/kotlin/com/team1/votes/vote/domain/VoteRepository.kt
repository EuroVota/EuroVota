package com.team1.votes.vote.domain

interface VoteRepository {

  fun save(vote: Vote): VoteId

  fun findByCountryName(countryName: CountryName): Vote?

  fun findByUserId(userId: UserId): List<Vote>

}
package com.team1.votes.vote.application

import com.auth0.jwt.JWTVerifier
import com.google.i18n.phonenumbers.PhoneNumberUtil
import com.google.i18n.phonenumbers.geocoding.PhoneNumberOfflineGeocoder
import com.team1.votes.shared.exception.UnauthorizedException
import com.team1.votes.utils.JwtDecoder
import com.team1.votes.vote.application.exception.CountryInvalidException
import com.team1.votes.vote.application.exception.CountryNotFoundException
import com.team1.votes.vote.application.exception.VoteLimitException
import com.team1.votes.vote.domain.*
import java.util.*

class GetRankingUseCase(
  private val voteRepository: VoteRepository,
  private val jwtVerifier: JWTVerifier
) {

  fun getRanking( bearerToken: String): List<Pair<String, Int>> {


    val userId = JwtDecoder().getUserId(jwtVerifier, bearerToken).let { UserId.fromString(it) }

    val votes = voteRepository.getVotes()

    val votesByCountry = mutableMapOf<String, Int>()

    votes.forEach { vote ->
      val countryName = vote.countryName.value
      val voteValue = vote.voteValue.value

      votesByCountry[countryName] = votesByCountry.getOrDefault(countryName, 0) + voteValue
    }


    return votesByCountry.toList().sortedByDescending { it.second }

  }


}
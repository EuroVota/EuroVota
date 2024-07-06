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

class VoteCreateUseCase(
  private val voteRepository: VoteRepository,
  private val countryList: List<String>,
  private val phoneNumberUtil: PhoneNumberUtil,
  private val geocoder: PhoneNumberOfflineGeocoder,
  private val jwtVerifier: JWTVerifier
) {

  fun create(countryName: CountryName, voteValue: VoteValue, bearerToken: String): VoteId {

    if (countryName.value !in countryList) {
      throw CountryNotFoundException()
    }

    val userId = JwtDecoder().getUserId(jwtVerifier, bearerToken).let { UserId.fromString(it) }

    val phoneNumberFromToken =
      JwtDecoder().getClaims(jwtVerifier, bearerToken)["phone_number"]?.asString() ?: throw UnauthorizedException()

    val phoneNumber = phoneNumberUtil
      .parse(phoneNumberFromToken, "")
      .let { phoneNumberUtil.format(it, PhoneNumberUtil.PhoneNumberFormat.INTERNATIONAL) }
      .let { phoneNumberUtil.parse(it, "") }

    val countryDescriptionNumber = geocoder.getDescriptionForNumber(phoneNumber, Locale.ENGLISH)

    if (countryDescriptionNumber.equals(countryName.value)) {
      throw CountryInvalidException()
    }

    val voteList = voteRepository.findByUserId(userId)

    if (voteList.size >= 5) {
      throw VoteLimitException()
    }

    return Vote
      .create(
        userId,
        countryName,
        voteValue
      )
      .run { voteRepository.save(this) }

  }


}
package com.team1.votes.shared

import com.auth0.jwt.JWTVerifier
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.i18n.phonenumbers.PhoneNumberUtil
import com.google.i18n.phonenumbers.geocoding.PhoneNumberOfflineGeocoder
import com.team1.users.utils.InstantTypeAdapter
import com.team1.votes.vote.application.VoteCreateUseCase
import com.team1.votes.vote.domain.VoteRepository
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import java.time.Instant

@Configuration
class DependencyInjectionConfig {

  @Value("\${app.aws.region}")
  lateinit var region: String

  @Bean
  fun gson(): Gson = GsonBuilder()
    .registerTypeAdapter(Instant::class.java, InstantTypeAdapter())
    .create()

  @Bean
  fun phoneNumberUtil(): PhoneNumberUtil = PhoneNumberUtil.getInstance()

  @Bean
  fun geocoder(): PhoneNumberOfflineGeocoder = PhoneNumberOfflineGeocoder.getInstance()

  @Bean
  fun voteCreateUseCase(
    voteRepository: VoteRepository,
    countryList: List<String>,
    phoneNumberUtil: PhoneNumberUtil,
    geocoder: PhoneNumberOfflineGeocoder,
    jwtVerifier: JWTVerifier
  ): VoteCreateUseCase = VoteCreateUseCase(
    voteRepository,
    countryList,
    phoneNumberUtil,
    geocoder,
    jwtVerifier
  )

}
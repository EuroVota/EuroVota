package com.team1.votes.vote.infrastructure.repository.rest.create


import com.team1.votes.shared.exception.UnauthorizedException
import com.team1.votes.vote.application.VoteCreateUseCase
import com.team1.votes.vote.application.exception.CountryInvalidException
import com.team1.votes.vote.application.exception.CountryNotFoundException
import com.team1.votes.vote.application.exception.InvalidPhoneNumberException
import com.team1.votes.vote.application.exception.VoteLimitException
import com.team1.votes.vote.domain.CountryName
import com.team1.votes.vote.domain.VoteValue
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RestController
import java.net.URI


@RestController
class PostCreateVoteController(private val voteCreateUseCase: VoteCreateUseCase) {

  @PostMapping("/votes")
  fun execute(
    @RequestBody request: CreateVoteRequest,
    @RequestHeader("Authorization") token: String
  ): ResponseEntity<String> {

    return try {
      val voteId = voteCreateUseCase
        .create(
          CountryName(request.countryName),
          VoteValue(request.voteValue),
          token
        )

      ResponseEntity.created(URI.create("/votes/${voteId.value}")).build()

    } catch (exception: Throwable) {
      when (exception) {
        is InvalidPhoneNumberException -> ResponseEntity
          .status(HttpStatus.BAD_REQUEST)
          .body(exception.message)

        is UnauthorizedException -> ResponseEntity
          .status(HttpStatus.UNAUTHORIZED)
          .body(exception.message)

        is CountryNotFoundException -> ResponseEntity
          .status(HttpStatus.NOT_FOUND)
          .body(exception.message)

        is VoteLimitException, is CountryInvalidException -> ResponseEntity
          .status(HttpStatus.CONFLICT)
          .body(exception.message)

        else -> ResponseEntity
          .status(HttpStatus.INTERNAL_SERVER_ERROR)
          .body(exception.message.toString())

      }
    }

  }

}

/*fun main() {

  val countryCodes = Locale.getISOCountries()

  // Iterar sobre los códigos de países y mostrar sus nombres
  for (countryCode in countryCodes) {
    val locale = Locale("", countryCode)
    val countryName = locale.getDisplayCountry(Locale.ENGLISH)
    println("$countryCode - $countryName")
  }

}*/


data class CreateVoteRequest(
  val countryName: String = "",
  val voteValue: Int = 0
)
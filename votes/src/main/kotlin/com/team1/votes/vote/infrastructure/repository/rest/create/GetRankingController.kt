package com.team1.votes.vote.infrastructure.repository.rest.create


import com.team1.votes.shared.exception.UnauthorizedException
import com.team1.votes.vote.application.GetRankingUseCase
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RestController


@RestController
class GetRankingController(private val getRankingUseCase: GetRankingUseCase) {

  @GetMapping("/votes")
  fun execute(
    @RequestHeader("Authorization") token: String
  ): ResponseEntity<Any> {

    return try {
      val voteId = getRankingUseCase.getRanking(token)

      ResponseEntity.ok().body(voteId)

    } catch (exception: Throwable) {
      when (exception) {
        is UnauthorizedException -> ResponseEntity
          .status(HttpStatus.UNAUTHORIZED)
          .body(exception.message)

        else -> ResponseEntity
          .status(HttpStatus.INTERNAL_SERVER_ERROR)
          .body(exception.message.toString())

      }
    }

  }


}




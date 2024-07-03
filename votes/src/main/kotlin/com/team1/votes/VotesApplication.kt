package com.team1.votes

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class VotesApplication

fun main(args: Array<String>) {
	runApplication<VotesApplication>(*args)
}

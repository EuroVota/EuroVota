package com.team1.votes

import io.github.cdimascio.dotenv.Dotenv
import io.github.cdimascio.dotenv.DotenvEntry
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import java.util.function.Consumer

@SpringBootApplication
class VotesApplication

fun main(args: Array<String>) {
  Dotenv
    .configure()
    .directory("votes")
    .load()
    .entries()
    .forEach(
      Consumer { entry: DotenvEntry ->
        System.setProperty(
          entry.key,
          entry.value
        )
      }
    )
  runApplication<VotesApplication>(*args)
}

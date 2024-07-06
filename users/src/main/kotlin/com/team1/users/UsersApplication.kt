package com.team1.users

import io.github.cdimascio.dotenv.Dotenv
import io.github.cdimascio.dotenv.DotenvEntry
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import java.util.function.Consumer


@SpringBootApplication
class UsersApplication

fun main(args: Array<String>) {
  Dotenv
    .configure()
    .directory("users")
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
  runApplication<UsersApplication>(*args)
}

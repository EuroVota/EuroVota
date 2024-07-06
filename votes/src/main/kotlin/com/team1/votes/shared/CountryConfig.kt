package com.team1.votes.shared

import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.core.io.ClassPathResource
import org.springframework.core.io.Resource
import java.nio.file.Files
import java.nio.file.Paths

@Configuration
class CountryConfig {

  @Bean
  fun countryList(): List<String> {
    val resource: Resource = ClassPathResource("countries.txt")
    val path = Paths.get(resource.uri)
    return Files.readAllLines(path)
  }
}
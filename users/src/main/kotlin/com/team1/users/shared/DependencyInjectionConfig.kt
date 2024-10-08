package com.team1.users.shared

import com.auth0.jwt.JWTVerifier
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.team1.users.session.infrastructure.repository.SessionCognitoRepository
import com.team1.users.user.application.UserCreateUseCase
import com.team1.users.user.application.UserGetUseCase
import com.team1.users.user.application.UserLoginUseCase
import com.team1.users.user.application.UserValidateUseCase
import com.team1.users.user.domain.UserRepository
import com.team1.users.utils.InstantTypeAdapter
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import java.time.Instant

@Configuration
class DependencyInjectionConfig {

  @Bean
  fun gson(): Gson = GsonBuilder()
    .registerTypeAdapter(Instant::class.java, InstantTypeAdapter())
    .create()

  @Bean
  fun userGetUseCase(userRepository: UserRepository, jwtVerifier: JWTVerifier): UserGetUseCase =
    UserGetUseCase(userRepository, jwtVerifier)

  @Bean
  fun userCreateUserCase(userRepository: UserRepository) = UserCreateUseCase(userRepository)

  @Bean
  fun userValidateUseCase(userRepository: UserRepository) = UserValidateUseCase(userRepository)

  @Bean
  fun userLoginUseCase(sessionCognitoRepository: SessionCognitoRepository) = UserLoginUseCase(sessionCognitoRepository)


}
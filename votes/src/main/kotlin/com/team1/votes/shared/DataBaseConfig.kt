package com.team1.votes.shared


import com.team1.votes.vote.infrastructure.repository.dynamoDB.DynamoDBVoteRepository
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.dynamodb.DynamoDbClient


@Configuration
class DataBaseConfig {

  @Value("\${app.aws.region}")
  lateinit var region: String


  @Bean
  fun dynamoDBClient(): DynamoDbClient = DynamoDbClient
    .builder()
    .region(Region.of(region))
    .build()


  @Bean
  fun voteRepository(dynamoDbClient: DynamoDbClient) = DynamoDBVoteRepository(dynamoDbClient)



}
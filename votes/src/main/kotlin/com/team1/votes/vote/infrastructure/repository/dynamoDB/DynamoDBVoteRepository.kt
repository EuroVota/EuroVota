package com.team1.votes.vote.infrastructure.repository.dynamoDB

import com.team1.votes.vote.domain.*
import software.amazon.awssdk.services.dynamodb.DynamoDbClient
import software.amazon.awssdk.services.dynamodb.model.*
import java.time.Instant


class DynamoDBVoteRepository(private val dynamoDbClient: DynamoDbClient) : VoteRepository {

  object DbConstants {
    const val TABLE_NAME = "votes"
  }

  override fun save(vote: Vote): VoteId {

    val voteAttributeMap = this.serialize(vote)

    val request = PutItemRequest.builder()
      .tableName(DbConstants.TABLE_NAME)
      .item(voteAttributeMap)
      .build()

    try {
      dynamoDbClient.putItem(request)
    } catch (e: ResourceNotFoundException) {
      System.err.format("Error: The Amazon DynamoDB table \"%s\" can't be found.\n", DbConstants.TABLE_NAME)
      System.err.println("Be sure that it exists and that you've typed its name correctly!")
    } catch (e: DynamoDbException) {
      System.err.println(e.message)
    }

    return vote.id
  }

  private fun serialize(vote: Vote) = mapOf(
    "countryName" to AttributeValue.builder().s(vote.countryName.value).build(),
    "userId" to AttributeValue.builder().s(vote.userId.value.toString()).build(),
    "id" to AttributeValue.builder().s(vote.id.value.toString()).build(),
    "createdAt" to AttributeValue.builder().s(vote.createdAt.toString()).build(),
    "voteValue" to AttributeValue.builder().n(vote.voteValue.value.toString()).build()
  )


  override fun findByCountryName(countryName: CountryName): Vote? {
    TODO("Not yet implemented")
  }

  override fun findByUserId(userId: UserId): List<Vote> {

    val filterExpression = "userId = :userId"

    val expressionAttributeValues = mapOf(
      ":userId" to AttributeValue.builder().s(userId.value.toString()).build()
    )

    val scanRequest = ScanRequest.builder()
      .tableName(DbConstants.TABLE_NAME)
      .filterExpression(filterExpression)
      .expressionAttributeValues(expressionAttributeValues)
      .build()

    val response: ScanResponse = dynamoDbClient.scan(scanRequest)
    val votes = response.items().map(::deserialize)

    return votes

  }

  private fun deserialize(item: Map<String, AttributeValue>): Vote {
    return Vote(
      VoteId.fromString(item["id"]?.s() ?: ""),
      UserId.fromString(item["userId"]?.s() ?: ""),
      CountryName(item["countryName"]?.s() ?: ""),
      Instant.parse(item["createdAt"]?.s()),
      VoteValue(item["voteValue"]?.n()?.toInt() ?: 0)
    )
  }

  override fun getVotes(): List<Vote> {
    val scanRequest = ScanRequest.builder()
      .tableName("votes")
      //.projectionExpression("countryName, voteValue")
      .build()

    val response = dynamoDbClient.scan(scanRequest)

    return response.items().map(::deserialize)
  }
}
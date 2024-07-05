output "eurovision_votes_table_name" {
  description = "Nombre de la tabla de votos de Eurovision"
  value       = aws_dynamodb_table.EurovisionVotes.name
}

output "eurovision_votes_table_arn" {
  description = "ARN de la tabla de votos de Eurovision"
  value       = aws_dynamodb_table.EurovisionVotes.arn
}

output "votes_by_country_index_name" {
  description = "Nombre del índice global secundario para votos por país"
  value       = aws_dynamodb_table.EurovisionVotes.global_secondary_index[0].name
}

output "country_ranking_table_name" {
  description = "Nombre de la tabla de ranking de países"
  value       = aws_dynamodb_table.CountryRanking.name
}

output "country_ranking_table_arn" {
  description = "ARN de la tabla de ranking de países"
  value       = aws_dynamodb_table.CountryRanking.arn
}
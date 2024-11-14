resource "random_password" "paz_secret_password" {
  length  = 20
  special = false
}

resource "aws_secretsmanager_secret" "secrets_paz" {
  name = "paz_secrets"
}

resource "aws_secretsmanager_secret_version" "secrets_version_paz" {
  secret_id     = aws_secretsmanager_secret.secrets_paz.id
  secret_string = jsonencode({
    BCRYPT_SALT       = "10"
    JWT_EXPIRATION    = "2d"
    JWT_SECRET_KEY    = random_password.paz_secret_password.result
    DB_URL            = "postgres://${module.rds_paz.db_instance_username}:${random_password.paz_database_password.result}@${module.rds_paz.db_instance_address}:5432/${module.rds_paz.db_instance_name}"
  })
}

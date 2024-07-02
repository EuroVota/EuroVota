resource "aws_cognito_user_pool" "users2" {
  auto_verified_attributes   = ["phone_number"]
  custom_domain              = null
  deletion_protection        = "ACTIVE"
  domain                     = null
  email_verification_message = null
  email_verification_subject = null
  mfa_configuration          = "OPTIONAL"
  name                       = "users2"
  sms_authentication_message = "Your verification code is {####}"
  sms_verification_message   = "Your verification code is {####}"
  tags                       = {}
  tags_all                   = {}
  username_attributes        = ["phone_number"]

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 1
    }
  }

  admin_create_user_config {
    allow_admin_create_user_only = false
  }

  email_configuration {
    configuration_set      = null
    email_sending_account  = "COGNITO_DEFAULT"
    from_email_address     = null
    reply_to_email_address = null
    source_arn             = null
  }

  password_policy {
    minimum_length                   = 8
    require_lowercase                = true
    require_numbers                  = true
    require_symbols                  = true
    require_uppercase                = true
    temporary_password_validity_days = 7
  }

  schema {
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    name                     = "phone_number"
    required                 = true

    string_attribute_constraints {
      max_length = "2048"
      min_length = "0"
    }
  }

  sms_configuration {
    external_id    = "test-external-id-x"
    sns_caller_arn = "arn:aws:iam::273440013219:role/LabRole"
    sns_region     = "us-east-1"
  }

  user_attribute_update_settings {
    attributes_require_verification_before_update = [
      "phone_number",
    ]
  }

  username_configuration {
    case_sensitive = false
  }

  verification_message_template {
    default_email_option  = "CONFIRM_WITH_CODE"
    email_message         = null
    email_message_by_link = null
    email_subject         = null
    email_subject_by_link = null
    sms_message           = null
  }
}

resource "aws_cognito_user_pool_client" "app_user" {
  access_token_validity                         = 60
  allowed_oauth_flows                           = []
  allowed_oauth_flows_user_pool_client          = false
  allowed_oauth_scopes                          = []
  auth_session_validity                         = 3
  callback_urls                                 = []
  default_redirect_uri                          = null
  enable_propagate_additional_user_context_data = false
  enable_token_revocation                       = true
  explicit_auth_flows = [
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
  ]
  id_token_validity             = 60
  logout_urls                   = []
  name                          = "app-user"
  prevent_user_existence_errors = "ENABLED"
  read_attributes = [
    "address",
    "birthdate",
    "email",
    "email_verified",
    "family_name",
    "gender",
    "given_name",
    "locale",
    "middle_name",
    "name",
    "nickname",
    "phone_number",
    "phone_number_verified",
    "picture",
    "preferred_username",
    "profile",
    "updated_at",
    "website",
    "zoneinfo",
  ]
  refresh_token_validity       = 30
  supported_identity_providers = []
  user_pool_id                 = "us-east-1_85qWTSXDm"
  write_attributes = [
    "address",
    "birthdate",
    "email",
    "family_name",
    "gender",
    "given_name",
    "locale",
    "middle_name",
    "name",
    "nickname",
    "phone_number",
    "picture",
    "preferred_username",
    "profile",
    "updated_at",
    "website",
    "zoneinfo",
  ]

  token_validity_units {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }

}
package com.team1.votes.utils

import com.auth0.jwk.JwkException
import com.auth0.jwk.JwkProvider
import com.auth0.jwk.JwkProviderBuilder
import com.auth0.jwt.interfaces.RSAKeyProvider
import java.net.MalformedURLException
import java.net.URL
import java.security.interfaces.RSAPrivateKey
import java.security.interfaces.RSAPublicKey


class AwsCognitoRSAKeyProvider(awsCognitoRegion: String?, awsUserPoolsId: String?) : RSAKeyProvider {
  private var awsKidStoreUrl: URL? = null
  private val provider: JwkProvider

  init {
    val url = String.format(
      "https://cognito-idp.%s.amazonaws.com/%s/.well-known/jwks.json",
      awsCognitoRegion,
      awsUserPoolsId
    )
    try {
      awsKidStoreUrl = URL(url)
    } catch (e: MalformedURLException) {
      throw RuntimeException(String.format("Invalid URL provided, URL=%s", url))
    }
    provider = JwkProviderBuilder(awsKidStoreUrl).build()
  }


  override fun getPublicKeyById(kid: String): RSAPublicKey {
    try {
      return provider[kid].publicKey as RSAPublicKey
    } catch (e: JwkException) {
      throw RuntimeException(
        java.lang.String.format(
          "Failed to get JWT kid=%s from aws_kid_store_url=%s",
          kid,
          awsKidStoreUrl
        )
      )
    }
  }

  override fun getPrivateKey(): RSAPrivateKey? {
    return null
  }

  override fun getPrivateKeyId(): String? {
    return null
  }
}
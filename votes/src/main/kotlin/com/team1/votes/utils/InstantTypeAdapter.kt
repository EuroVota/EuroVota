package com.team1.users.utils

import com.google.gson.TypeAdapter
import com.google.gson.stream.JsonReader
import com.google.gson.stream.JsonWriter
import java.time.Instant

class InstantTypeAdapter : TypeAdapter<Instant>() {
  override fun write(out: JsonWriter, value: Instant?) {
    if (value == null) {
      out.nullValue()
    } else {
      out.value(value.toString())
    }
  }

  override fun read(`in`: JsonReader): Instant? {
    return if (`in`.peek() == com.google.gson.stream.JsonToken.NULL) {
      `in`.nextNull()
      null
    } else {
      Instant.parse(`in`.nextString())
    }
  }
}
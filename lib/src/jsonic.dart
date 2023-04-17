import 'dart:convert';

import 'package:jsonic/src/jsonic_error.dart';
import 'package:jsonic/src/jsonic_field.dart';

class Jsonic {
  final List<JsonicField> _fields = [];

  /// adds a [field] to [_fields]
  Jsonic add<T>(JsonicField<T> field) {
    _fields.add(field);
    return this;
  }

  /// adds [fields] to [_fields]
  Jsonic addAll(List<JsonicField> fields) {
    _fields.addAll(fields);
    return this;
  }

  List<JsonicField> get fields => _fields;

  ///decodes a json [encoded], pushes each value to the specific [JsonField]
  void decode(String encoded) {
    Map<String, dynamic> raw = {};

    try {
      raw = jsonDecode(encoded);
    } on TypeError {
      throw MalformedJson();
    } on FormatException {
      throw MalformedJson();
    }

    for (JsonicField f in _fields) {
      f.pushValue(raw[f.mapping]);
    }
  }

  ///uses decode function to decode [encoded] and return a decoded map
  Map<String, dynamic> decodeToMap(String encoded) {
    Map<String, dynamic> decoded = {};

    decode(encoded);

    for (JsonicField f in _fields) {
      decoded[f.mapping] = f.value;
    }

    return decoded;
  }
}

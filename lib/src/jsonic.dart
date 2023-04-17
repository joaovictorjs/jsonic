import 'dart:convert';

import 'package:jsonic/src/jsonic_error.dart';
import 'package:jsonic/src/jsonic_field.dart';

class Jsonic {
  List<JsonicField> _fields = [];
  Map<String, dynamic> _decoded = {};

  Jsonic add<T>(JsonicField<T> field) {
    _fields.add(field);
    return this;
  }

  List<JsonicField> get fields => _fields;

  Map<String, dynamic> get decoded => _decoded;

  ///decodes a json [encoded], pushes each value to the specific [JsonField] and returns a decode map
  Map<String, dynamic> decodeJson(String encoded) {
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

    for (JsonicField f in _fields) {
      _decoded[f.mapping] = f.value;
    }

    return _decoded;
  }
}

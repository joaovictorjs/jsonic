import "dart:convert";

import "package:jsonic/jsonic.dart";
import "package:jsonic/src/jsonic_error.dart";
import "package:jsonic/src/jsonic_field.dart";
import "package:test/test.dart";

void main() {
  group('add', () {
    Jsonic jsonic = Jsonic();

    test("should add a field", () {
      jsonic.add<String>(JsonicField(mapping: "name")).add<int>(JsonicField(mapping: "age"));

      expect(jsonic.fields.length, 2);
      expect(jsonic.fields[0].mapping, "name");
      expect(jsonic.fields[1].mapping, "age");
    });
  });

  group("decodeJson", () {
    Jsonic jsonic = Jsonic()
        .add<String>(JsonicField(mapping: "name"))
        .add<int>(JsonicField(mapping: "age"))
        .add<String>(JsonicField(mapping: "status", fallback: "ACTIVE"));

    String encoded = jsonEncode({"name": "person's name", "age": 123});

    test("should throws a MalformedJson", () {
      try {
        jsonic.decodeJson(jsonEncode(""));
      } on Error catch (e) {
        expect(e, isA<MalformedJson>());
      }
    });
  });
}

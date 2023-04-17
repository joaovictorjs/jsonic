import "dart:convert";

import "package:jsonic/jsonic.dart";
import "package:jsonic/src/jsonic_error.dart";
import "package:jsonic/src/jsonic_field.dart";
import "package:test/test.dart";

void main() {
  group('add', () {
    Jsonic jsonic = Jsonic();

    test("should add a field", () {
      jsonic
          .add<String>(JsonicField(mapping: "name"))
          .add<int>(JsonicField(mapping: "age"));

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

    var raw = {"name": "person's name", "age": 123};
    String encoded = jsonEncode(raw);

    test("should throws a MalformedJson", () {
      try {
        jsonic.decode(jsonEncode(""));
      } on Error catch (e) {
        expect(e, isA<MalformedJson>());
      }
    });

    test("should returns a map with status = ACTIVE", () {
      var decoded = jsonic.decodeToMap(encoded);

      expect(decoded["status"], "ACTIVE");
      expect(decoded["name"], raw["name"]);
      expect(decoded["age"], raw["age"]);
    });

    test("should throws an InvalidNullValue", () {
      jsonic.add<Map>(JsonicField(mapping: "parents"));

      try {
        jsonic.decode(encoded);
      } on Error catch (e) {
        expect(e, isA<InvalidNullValue>());
      }

      jsonic.fields.removeLast();
    });

    test("should not throws an InvalidNullValue", () {
      jsonic.add<String>(JsonicField(mapping: "email", nullable: true));

      var decoded = jsonic.decodeToMap(encoded);

      expect(decoded["status"], "ACTIVE");
      expect(decoded["name"], raw["name"]);
      expect(decoded["age"], raw["age"]);
    });
  });
}

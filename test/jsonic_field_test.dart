import 'dart:convert';

import 'package:jsonic/src/jsonic_error.dart';
import 'package:jsonic/src/jsonic_field.dart';
import 'package:test/test.dart';

void main() {
  group("pushValue", () {
    var name = JsonicField<String>(mapping: "name");

    tearDown(() {
      name.fallback = null;
      name.nullable = false;
    });

    test("should throws an InvalidNullValue", () {
      try {
        name.pushValue(null);
      } on Error catch (e) {
        expect(e, isA<InvalidNullValue>());
      }
    });

    test("should throws a NotAcceptedValue", () {
      JsonicField status = JsonicField(
        mapping: "status",
        acceptedValues: ["ACTIVE", "INACTIVE"],
      );

      try {
        status.pushValue("ALIVE");
      } on Error catch (e) {
        expect(e, isA<NotAcceptedValue>());
        expect((e as NotAcceptedValue).acceptedValues, ["ACTIVE", "INACTIVE"]);
      }
    });

    group("value should be equals to 'some random name'", () {
      test("via fallback", () {
        name.fallback = 'some random name';

        name.pushValue(null);

        expect(name.value, "some random name");
      });

      test("via pushValue", () {
        name.pushValue('some random name');

        expect(name.value, 'some random name');
      });
    });

    test("should not throws a MismatchType", () {
      var encoded = jsonEncode({
        "parents": {"mother": "grandmother"},
      });

      var parentsField = JsonicField<Map>(mapping: "parents");

      parentsField.pushValue(jsonDecode(encoded)["parents"]);

      expect(parentsField.value, isA<Map>());
      expect(parentsField.value["mother"], "grandmother");
    });

    test("should throws a Mismatch exception", () {
      try {
        name.pushValue(123);
      } on Error catch (e) {
        expect(e, isA<MismatchType>());
        expect((e as MismatchType).mapping, "name");
        expect(e.expected, "String");
        expect(e.gotten, "int");
      }
    });
  });
}

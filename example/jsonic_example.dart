import 'dart:convert';

import 'package:jsonic/jsonic.dart';
import 'package:jsonic/src/jsonic_field.dart';

class Person {
  JsonicField name = JsonicField<String>(mapping: "name");
  JsonicField email = JsonicField<String>(mapping: "email", nullable: true);
  JsonicField phone = JsonicField<String>(mapping: "phone", nullable: true);
  JsonicField cell = JsonicField<String>(mapping: "cell", nullable: true);
  JsonicField status = JsonicField<String>(mapping: "status", fallback: "ACTIVE");
  JsonicField age = JsonicField<int>(mapping: "age");
  static late Jsonic jsonic;

  Person() {
    jsonic = Jsonic().addAll([name, email, phone, cell, status, age]);
  }

  factory Person.fromJson(String json) {
    Person p = Person();
    jsonic.decode(json);
    return p;
  }
}

void main() {
  var jsonFromWeb = jsonEncode({
    "name": "John Doe",
    "email": "john@doe.com",
    "age": 12,
  });

  var person = Person.fromJson(jsonFromWeb);

  print('''
name: ${person.name.value},
email: ${person.email.value},
phone: ${person.phone.value},
cell: ${person.cell.value},
status: ${person.status.value},
age: ${person.age.value},
''');
}

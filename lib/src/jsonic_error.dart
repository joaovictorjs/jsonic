abstract class JsonicError extends Error {
  String? mapping;

  JsonicError({this.mapping});
}

class InvalidNullValue extends JsonicError {
  InvalidNullValue({super.mapping});
}

class MismatchType extends JsonicError {
  String expected, gotten;
  MismatchType({
    super.mapping,
    required this.expected,
    required this.gotten,
  });
}

class MalformedJson extends JsonicError {}

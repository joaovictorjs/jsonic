import 'package:jsonic/src/jsonic_error.dart';

class JsonicField<T> {
  /// json's key
  String mapping;

  /// value gotten from json
  dynamic _value;

  /// if json gives a null and [nullable] is false, [fallback] will be given as a value
  dynamic fallback;

  /// if true, it accepts null value, if false will try to get [fallback] value
  bool nullable;

  JsonicField({
    required this.mapping,
    this.fallback,
    this.nullable = false,
  });

  void pushValue(dynamic value) {
    if (value == null) {
      if (nullable) {
        _value = null;
      } else {
        if (fallback == null) throw InvalidNullValue(mapping: mapping);
        assert(fallback is T, "fallback type should be same as T");
        _value = fallback;
      }
      return;
    }

    if (value is T) {
      _value = value;
    } else {
      throw MismatchType(
        mapping: mapping,
        expected: T.toString(),
        gotten: value.runtimeType.toString(),
      );
    }
  }

  dynamic get value => _value;
}

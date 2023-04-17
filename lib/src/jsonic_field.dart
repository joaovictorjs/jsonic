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

  /// a list of accepted values, if json provider a vulue that is not included in this list, it will throw a NotAcceptedValue
  List<dynamic>? acceptedValues;

  /// min lenght of a type
  int? min;

  /// max lenght of a type
  int? max;

  JsonicField({
    required this.mapping,
    this.fallback,
    this.nullable = false,
    this.acceptedValues,
    this.max,
    this.min,
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
      if (acceptedValues != null) {
        if (!acceptedValues!.contains(value)) {
          throw NotAcceptedValue(
            acceptedValues: acceptedValues!,
            gotten: value,
            mapping: mapping,
          );
        }
      }

      if (min != null && !_validateMin(value)) {
        throw MinLengthError(expected: min!, mapping: mapping);
      }

      if (max != null && !_validateMax(value)) {
        throw MaxLengthError(expected: max!, mapping: mapping);
      }

      _value = value;
    } else {
      throw MismatchType(
        mapping: mapping,
        expected: T.toString(),
        gotten: value.runtimeType.toString(),
      );
    }
  }

  bool _validateMin(T value) {
    if (value is String) {
      return value.length >= min!;
    }

    if (value is int || value is double) {
      return (value as num) >= min!;
    }

    if (value is Iterable) {
      return value.length >= min!;
    }

    return false;
  }

  bool _validateMax(T value) {
    if (value is String) {
      return value.length <= max!;
    }

    if (value is int || value is double) {
      return (value as num) <= max!;
    }

    if (value is Iterable) {
      return value.length <= max!;
    }

    return false;
  }

  dynamic get value => _value;
}

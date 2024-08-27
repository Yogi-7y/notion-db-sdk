import 'exception.dart';

typedef PropertyMetaData<T> = ({String name, String id, String type, T value});

PropertyMetaData<T?> getMetaData<T>({
  required Map<String, Object?> map,
  List<PropertyValidator> validators = const [],
}) {
  for (final validator in validators) {
    validator.validate(map);
  }

  final _name = map.keys.first;
  final _data = map[_name] as Map<String, Object?>? ?? {};

  final _id = _data['id'] as String? ?? '';
  final _type = _data['type'] as String? ?? '';
  final _value = _data[_type] as T?;

  return (id: _id, name: _name, type: _type, value: _value);
}

abstract class PropertyValidator {
  PropertyValidator? _nextValidator;

  // ignore: use_setters_to_change_properties
  void setNext(PropertyValidator validator) {
    _nextValidator = validator;
  }

  void validate(Map<String, Object?> map);
}

/// Ensures that the map has only one key-value pair.
/// The single key present is the name of the property.
class MapLengthValidator extends PropertyValidator {
  @override
  void validate(Map<String, Object?> map) {
    if (map.length != 1) throw InvalidMapLengthException(map: map);

    _nextValidator?.validate(map);
  }
}

/// Ensures that the property type is of the expected type.
@Deprecated('Use PropertyTypeListValidator instead.')
class PropertyTypeValidator extends PropertyValidator {
  @Deprecated('Use PropertyTypeListValidator instead.')
  PropertyTypeValidator({
    required this.expectedType,
  });

  final String expectedType;

  @override
  void validate(Map<String, Object?> map) {
    final _data = map.values.first as Map<String, Object?>? ?? {};

    final _type = _data['type'] as String?;

    if (_type == null || _type != expectedType)
      throw InvalidPropertyTypeException(
        map: map,
        expectedType: expectedType,
      );

    _nextValidator?.validate(map);
  }
}

/// Ensures that the property type is one of the expected types.
class PropertyTypeListValidator extends PropertyValidator {
  PropertyTypeListValidator({
    required this.expectedTypes,
  });

  final List<String> expectedTypes;

  @override
  void validate(Map<String, Object?> map) {
    final _data = map.values.first as Map<String, Object?>? ?? {};

    final _type = _data['type'] as String?;

    if (_type == null || !expectedTypes.contains(_type))
      throw InvalidPropertyTypeException(
        map: map,
        expectedType: expectedTypes.join(' or '),
      );

    _nextValidator?.validate(map);
  }
}

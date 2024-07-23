/// Exception thrown when an error occurs during parsing the json to an Object.
class PropertyAdapterException implements Exception {
  const PropertyAdapterException({
    required this.message,
    required this.map,
  });

  final String message;
  final Map<String, Object?>? map;

  @override
  String toString() => 'PropertyAdapterException: $message';
}

/// Thrown when the given map has more than one key.
/// Expects a map with only one key, which is the name of the property.
///
/// ```dart
/// {
///   "Task completed": {
///    "id": "ZI%40W",
///     "type": "checkbox",
///     "checkbox": true
///   }
/// }
/// ```
class InvalidMapLengthException implements PropertyAdapterException {
  const InvalidMapLengthException({
    required this.map,
    this.message = 'Invalid map length. Expected a map with only one key.',
  });

  @override
  final String message;

  @override
  final Map<String, Object?> map;

  @override
  String toString() => 'InvalidMapLengthException(message: $message, map: $map)';
}

/// Thrown when the property type returned in json is not of expected type.
class InvalidPropertyTypeException implements PropertyAdapterException {
  const InvalidPropertyTypeException(
      {required this.map, required this.expectedType, this.message = 'Invalid property type.'});

  @override
  final String message;

  @override
  final Map<String, Object?> map;

  final String expectedType;

  @override
  String toString() =>
      'InvalidPropertyTypeException(message: $message, expectedType: $expectedType map: $map)';
}

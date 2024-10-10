import '../sort.dart';

/// Represents a property-based sort operation.
class PropertySort implements Sort {
  /// Creates a new [PropertySort] instance.
  ///
  /// [property] is the name of the property to sort by.
  /// [direction] specifies the sort direction (default is ascending).
  PropertySort({
    required this.property,
    this.direction = SortDirection.ascending,
  }) : assert(property.isNotEmpty, 'Property name cannot be empty');

  /// The name of the property to sort by.
  final String property;

  @override
  final SortDirection direction;

  @override
  Map<String, String> toMap() => {
        'property': property,
        'direction': direction.toString().split('.').last,
      };
}

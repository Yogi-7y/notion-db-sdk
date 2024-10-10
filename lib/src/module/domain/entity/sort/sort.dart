/// Represents a sort operation for Notion database queries.
abstract class Sort {
  const Sort({
    required this.direction,
  });

  /// The direction of the sort operation.
  final SortDirection direction;

  /// Converts the sort operation to a map representation.
  Map<String, String> toMap();
}

/// Represents the direction of a sort operation.
enum SortDirection {
  /// Sort in ascending order.
  ascending(value: 'ascending'),

  /// Sort in descending order.
  descending(value: 'descending');

  const SortDirection({
    required this.value,
  });

  /// The value which will be passed to the API.
  final String value;
}

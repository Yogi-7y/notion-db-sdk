import '../sort.dart';

/// Represents a timestamp-based sort operation.
class TimestampSort implements Sort {
  /// Creates a new [TimestampSort] instance.
  ///
  /// [timestamp] should be either 'created_time' or 'last_edited_time'.
  /// [direction] specifies the sort direction (default is ascending).
  TimestampSort({
    required this.timestamp,
    this.direction = SortDirection.ascending,
  }) : assert(
          timestamp == 'created_time' || timestamp == 'last_edited_time',
          "Timestamp must be either 'created_time' or 'last_edited_time'",
        );

  /// The type of timestamp to sort by.
  final String timestamp;

  @override
  final SortDirection direction;

  @override
  Map<String, String> toMap() => {
        'timestamp': timestamp,
        'direction': direction.toString().split('.').last,
      };
}

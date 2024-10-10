import 'sort.dart';
import 'variants/property_sort.dart';
import 'variants/timestamp_sort.dart';

/// A builder class for creating sort operations for Notion database queries.
class SortBuilder {
  final List<Sort> _sorts = [];

  /// Adds a property-based sort operation.
  ///
  /// [property] is the name of the property to sort by.
  /// [direction] specifies the sort direction (default is ascending).
  void addPropertySort(String property, {SortDirection direction = SortDirection.ascending}) {
    _sorts.add(PropertySort(property: property, direction: direction));
  }

  /// Adds a timestamp-based sort operation.
  ///
  /// [timestamp] should be either 'created_time' or 'last_edited_time'.
  /// [direction] specifies the sort direction (default is ascending).
  void addTimestampSort(String timestamp, {SortDirection direction = SortDirection.ascending}) {
    _sorts.add(TimestampSort(timestamp: timestamp, direction: direction));
  }

  /// Builds and returns the list of sort operations.
  List<Sort> build() => _sorts;
}

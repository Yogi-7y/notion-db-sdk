import 'package:meta/meta.dart';

/// An abstract class representing a filter in the Notion API.
///
/// This class serves as the base for all filter types used in database queries.
/// Concrete implementations of this class define specific filtering behaviors.
@immutable
abstract class Filter {
  /// Converts the filter to a map representation compatible with the Notion API.
  ///
  /// This method should be implemented by all concrete filter classes to provide
  /// the correct JSON structure for the API request.
  ///
  /// Returns a [Map<String, Object?>] representing the filter in Notion API format.
  Map<String, Object?> toMap();
}

/// A base class for filters that operate on specific properties of Notion database items.
///
/// This class extends [Filter] and adds a [property] field to specify which
/// property the filter should be applied to.
@immutable
abstract class PropertyFilter extends Filter {
  PropertyFilter(this.property);

  /// The name or ID of the property this filter applies to.
  final String property;
}

/// A compound filter that combines multiple filters with a logical AND operation.
///
/// This filter will only match database items that satisfy all of the sub-filters
/// it contains.
///
/// Throws an [AssertionError] if fewer than two filters are provided.
@immutable
class AndFilter extends Filter {
  AndFilter(this.filters)
      : assert(
          filters.length > 1,
          'AndFilter must contain at least two filters.',
        );

  /// The list of sub-filters to be combined with AND logic.
  final List<Filter> filters;

  @override
  Map<String, dynamic> toMap() => {
        'and': filters.map((filter) => filter.toMap()).toList(),
      };
}

/// A compound filter that combines multiple filters with a logical OR operation.
///
/// This filter will match database items that satisfy at least one of the sub-filters
/// it contains.
///
/// Throws an [AssertionError] if fewer than two filters are provided.
@immutable
class OrFilter extends Filter {
  OrFilter(this.filters)
      : assert(
          filters.length > 1,
          'OrFilter must contain at least two filters.',
        );

  /// The list of sub-filters to be combined with OR logic.
  final List<Filter> filters;

  @override
  Map<String, dynamic> toMap() => {
        'or': filters.map((filter) => filter.toMap()).toList(),
      };
}

/// An abstract base class for filters that can be applied to both regular properties
/// and formula properties in Notion databases.
///
/// This class extends [PropertyFilter] and adds functionality to handle formula
/// properties, which require a different structure in the API request.
@immutable
abstract class FormulaFilter extends PropertyFilter {
  /// Creates a new [FormulaFilter].
  ///
  /// The [property] parameter specifies the name or ID of the property to filter on.
  /// The [isFormulaProperty] parameter determines whether this filter is being
  /// applied to a formula property or a regular property.
  FormulaFilter(
    super.property, {
    this.isFormulaProperty = false,
  });

  /// Indicates whether this filter is being applied to a formula property.
  ///
  /// If true, the filter will be wrapped in a 'formula' object in the API request.
  /// If false, the filter will be treated as a regular property filter.
  final bool isFormulaProperty;

  @override
  Map<String, Object?> toMap() {
    if (isFormulaProperty) {
      return {
        'property': property,
        'formula': toMapWithoutPropertyKey(),
      };
    }

    return {'property': property, ...toMapWithoutPropertyKey()};
  }

  Map<String, Object?> toMapWithoutPropertyKey();

  /// Wraps the given [filterMap] in a 'formula' object if [isFormulaProperty] is true.
  ///
  /// This method is used internally by concrete implementations to ensure the
  /// correct structure for formula property filters.
  ///
  /// Returns a [Map<String, dynamic>] with the appropriate structure for the API request.
  Map<String, dynamic> wrapInFormula(Map<String, dynamic> filterMap) {
    if (isFormulaProperty) {
      return {
        'property': property,
        'formula': filterMap,
      };
    }
    return {'property': property, ...filterMap};
  }
}

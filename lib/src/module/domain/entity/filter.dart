import 'package:meta/meta.dart';

@immutable
abstract class Filter {
  Map<String, Object?> toMap();
}

@immutable
abstract class PropertyFilter extends Filter {
  PropertyFilter(this.property);

  final String property;
}

@immutable
class AndFilter extends Filter {
  AndFilter(this.filters)
      : assert(
          filters.length > 1,
          'AndFilter must contain at least two filters.',
        );

  final List<Filter> filters;

  @override
  Map<String, dynamic> toMap() => {
        'and': filters.map((filter) => filter.toMap()).toList(),
      };
}

@immutable
class OrFilter extends Filter {
  OrFilter(this.filters)
      : assert(
          filters.length > 1,
          'OrFilter must contain at least two filters.',
        );

  final List<Filter> filters;

  @override
  Map<String, dynamic> toMap() => {
        'or': filters.map((filter) => filter.toMap()).toList(),
      };
}

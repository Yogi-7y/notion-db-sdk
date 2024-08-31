// ignore_for_file: avoid_returning_this

import 'filter.dart';

class FilterBuilder {
  Filter? _filter;

  FilterBuilder and(List<Filter> filters) {
    _filter = AndFilter(filters);
    return this;
  }

  FilterBuilder or(List<Filter> filters) {
    _filter = OrFilter(filters);
    return this;
  }

  Filter build() {
    if (_filter == null) {
      throw StateError('No filter has been set. Use and() or or() to set a filter.');
    }
    return _filter!;
  }
}

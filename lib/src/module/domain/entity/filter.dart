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

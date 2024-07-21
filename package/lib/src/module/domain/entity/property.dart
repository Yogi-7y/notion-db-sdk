import 'package:meta/meta.dart';
import 'postable_property.dart';
import 'value.dart';

@immutable
abstract class Property<T extends Object> implements PostableProperty {
  const Property({
    required this.name,
    required this.type,
    this.id,
    this.valueDetails,
  });

  final String name;
  final String type;
  final String? id;
  final Value<T>? valueDetails;

  T? get value => valueDetails?.value;
}

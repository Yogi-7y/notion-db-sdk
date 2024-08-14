// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  @override
  bool operator ==(covariant Property<T> other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.type == type &&
        other.id == id &&
        other.valueDetails == valueDetails;
  }

  @override
  int get hashCode {
    return name.hashCode ^ type.hashCode ^ id.hashCode ^ valueDetails.hashCode;
  }

  @override
  String toString() {
    return 'Property(name: $name, type: $type, id: $id, valueDetails: $valueDetails)';
  }
}

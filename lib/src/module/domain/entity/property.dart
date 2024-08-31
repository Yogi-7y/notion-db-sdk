// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:meta/meta.dart';

import 'postable_property.dart';
import 'value.dart';

/// Represents a generic property in a Notion page. \
/// For example, Text, Number, Checkbox, etc.
@immutable
abstract class Property<T extends Object> implements PostableProperty {
  /// Creates a [Property] with the given [name], [type], [id], and [valueDetails].
  const Property({
    required this.name,
    required this.type,
    this.id,
    this.valueDetails,
  });

  /// The name of the property. This is the name given to the property in the Notion database.
  final String name;

  /// The type of the property. This is the type of the property in the Notion database.
  final String type;

  final String? id;

  final Value<T>? valueDetails;

  T? get value => valueDetails?.value;

  /// Converts the property to a map format suitable for Notion API requests.
  ///
  /// This method should be implemented by subclasses to provide
  /// type-specific serialization.
  @override
  Map<String, Object?> toMap();

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

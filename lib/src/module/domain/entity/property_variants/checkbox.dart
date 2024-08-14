import 'package:meta/meta.dart';

import '../property.dart';

@immutable
class Checkbox extends Property<bool> {
  const Checkbox({
    required super.name,
    required super.type,
    super.valueDetails,
    super.id,
  });

  static const propertyType = 'checkbox';

  @override
  Map<String, Object?> toMap() {
    return {
      name: {
        type: value,
      }
    };
  }
}

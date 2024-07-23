import 'package:meta/meta.dart';

import '../property.dart';

@immutable
class PhoneNumber extends Property<String> {
  const PhoneNumber({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  static const propertyType = 'phone_number';

  @override
  Map<String, Object?> toMap() => {
        name: {
          'phone_number': value,
        }
      };
}

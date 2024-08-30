import 'package:meta/meta.dart';

import '../property.dart';

const _phoneNumberType = 'phone_number';

@immutable
class PhoneNumber extends Property<String> {
  const PhoneNumber({
    required super.name,
    super.type = _phoneNumberType,
    super.id,
    super.valueDetails,
  });

  static const supportedTypes = [_phoneNumberType];

  @override
  Map<String, Object?> toMap() => {
        name: {
          'phone_number': value,
        }
      };
}

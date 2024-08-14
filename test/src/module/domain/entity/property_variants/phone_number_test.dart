import 'package:notion_db_sdk/src/module/domain/entity/property_variants/phone_number.dart';
import 'package:notion_db_sdk/src/module/domain/entity/value.dart';
import 'package:test/test.dart';

void main() {
  test(
    'phone number property successfully generates a map as per the contract',
    () {
      final _expectedMap = <String, Object?>{
        'Contact': {
          'phone_number': '+1 (555) 123-4567',
        }
      };

      const _phoneNumber = PhoneNumber(
        name: 'Contact',
        type: 'phone_number',
        valueDetails: Value(
          value: '+1 (555) 123-4567',
        ),
      );

      final _map = _phoneNumber.toMap();

      expect(_map, _expectedMap);
    },
  );
}

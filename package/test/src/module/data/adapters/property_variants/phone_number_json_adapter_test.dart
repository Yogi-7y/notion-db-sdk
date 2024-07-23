import 'package:package/src/core/errors/exception.dart';
import 'package:package/src/module/data/adapters/property_variants/phone_number_json_adapter.dart';
import 'package:package/src/module/domain/entity/property_variants/phone_number.dart';
import 'package:package/src/module/domain/entity/value.dart';
import 'package:test/test.dart';

void main() {
  group('PhoneNumberJsonAdapter', () {
    test(
      'throws InvalidMapLengthException when map has more than one key',
      () {
        final _map = {
          'Contact': {
            'id': '123',
            'type': 'phone_number',
          },
          'Extra': {
            'id': '456',
            'type': 'phone_number',
          },
        };
        expect(
          () => PhoneNumberJsonAdapter.fromMap(_map),
          throwsA(isA<InvalidMapLengthException>()),
        );
      },
    );

    test(
      'throws InvalidPropertyTypeException with correct expectedType when property type is invalid',
      () {
        final _map = {
          'Contact': {
            'id': '123',
            'type': 'string', // Intentionally incorrect type
            'phone_number': '+1 (555) 123-4567',
          },
        };
        expect(
          () async {
            try {
              PhoneNumberJsonAdapter.fromMap(_map);
            } catch (e) {
              if (e is InvalidPropertyTypeException) {
                expect(e.expectedType, 'phone_number');
                rethrow;
              }
            }
          },
          throwsA(isA<InvalidPropertyTypeException>()),
        );
      },
    );

    test(
      'converts json to phone number property variant correctly',
      () {
        final _map = {
          'Contact': {
            'id': '123',
            'type': 'phone_number',
            'phone_number': '+1 (555) 123-4567',
          },
        };
        final _phoneNumber = PhoneNumberJsonAdapter.fromMap(_map);
        const _expectedResult = PhoneNumber(
          name: 'Contact',
          type: 'phone_number',
          id: '123',
          valueDetails: Value(value: '+1 (555) 123-4567'),
        );
        expect(_phoneNumber, isA<PhoneNumber>());
        expect(_phoneNumber, equals(_expectedResult));
      },
    );
  });
}

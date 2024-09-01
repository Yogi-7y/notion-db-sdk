import 'package:notion_db_sdk/src/module/domain/entity/filters/phone_number_filter.dart';
import 'package:test/test.dart';

void main() {
  group('PhoneNumberFilter', () {
    test('constructor should create instance with equals condition', () {
      final filter = PhoneNumberFilter('Contact', equals: '+1234567890');
      expect(filter.property, equals('Contact'));
      expect(filter.equals, equals('+1234567890'));
    });

    test('constructor should throw assertion error when multiple conditions are specified', () {
      expect(
        () => PhoneNumberFilter('Contact', equals: '+1234567890', contains: '123'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('constructor should throw assertion error when no condition is specified', () {
      expect(
        () => PhoneNumberFilter('Contact'),
        throwsA(isA<AssertionError>()),
      );
    });

    test('toMap should return correct map for string condition', () {
      final filter = PhoneNumberFilter('Contact', contains: '123');
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Contact',
            'phone_number': {'contains': '123'},
          }));
    });

    test('toMap should return correct map for boolean condition', () {
      final filter = PhoneNumberFilter('Contact', isNotEmpty: true);
      final map = filter.toMap();
      expect(
          map,
          equals({
            'property': 'Contact',
            'phone_number': {'is_not_empty': true},
          }));
    });
  });
}

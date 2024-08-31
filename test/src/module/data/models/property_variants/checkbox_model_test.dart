import 'package:notion_db_sdk/src/core/errors/exception.dart';
import 'package:notion_db_sdk/src/module/data/models/property_variants/checkbox_model.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/checkbox.dart';
import 'package:notion_db_sdk/src/module/domain/entity/value.dart';
import 'package:test/test.dart';

void main() {
  test(
    'throws InvalidMapLengthException when map has more than 1 key',
    () {
      final _map = {
        'Task completed': {
          'id': 'ZI%40W',
          'type': 'checkbox',
          'checkbox': true,
        },
        'Task completed 2': {
          'id': 'ZI%40W',
          'type': 'checkbox',
          'checkbox': true,
        },
      };

      expect(
        () => CheckboxModel.fromMap(_map),
        throwsA(isA<InvalidMapLengthException>()),
      );
    },
  );

  test(
    'throws InvalidPropertyTypeException with correct expectedType when property type is invalid',
    () {
      final _map = {
        'Task completed': {
          'id': 'ZI%40W',
          'type': 'invalid_type', // Intentionally incorrect type
          'checkbox': true,
        },
      };

      expect(
        () async {
          try {
            CheckboxModel.fromMap(_map);
          } catch (e) {
            if (e is InvalidPropertyTypeException) {
              expect(e.expectedType, contains('checkbox'));
              rethrow;
            }
          }
        },
        throwsA(isA<InvalidPropertyTypeException>()),
      );
    },
  );

  test(
    'convert json to checkbox',
    () {
      final _map = {
        'Task completed': {
          'id': 'ZI%40W',
          'type': 'checkbox',
          'checkbox': true,
        },
      };

      final _checkbox = CheckboxModel.fromMap(_map);

      const _expectedResult = CheckboxProperty(
        name: 'Task completed',
        id: 'ZI%40W',
        valueDetails: Value(value: true),
      );

      expect(_checkbox, isA<CheckboxProperty>());
      expect(_checkbox, _expectedResult);
    },
  );
}

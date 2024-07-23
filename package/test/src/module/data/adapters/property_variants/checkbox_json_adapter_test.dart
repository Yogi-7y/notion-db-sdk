import 'package:package/src/core/errors/exception.dart';
import 'package:package/src/module/data/adapters/property_variants/checkbox_json_adapter.dart';
import 'package:package/src/module/domain/entity/property_variants/checkbox.dart';
import 'package:package/src/module/domain/entity/value.dart';
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
        () => CheckboxJsonAdapter.fromMap(_map),
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
            CheckboxJsonAdapter.fromMap(_map);
          } catch (e) {
            if (e is InvalidPropertyTypeException) {
              expect(e.expectedType, 'checkbox');
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

      final _checkbox = CheckboxJsonAdapter.fromMap(_map);

      const _expectedResult = Checkbox(
        name: 'Task completed',
        type: 'checkbox',
        id: 'ZI%40W',
        valueDetails: Value(value: true),
      );

      expect(_checkbox, isA<Checkbox>());
      expect(_checkbox, _expectedResult);
    },
  );
}

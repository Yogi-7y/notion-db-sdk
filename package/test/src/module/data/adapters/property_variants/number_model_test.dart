import 'package:notion_db_sdk/src/core/errors/exception.dart';
import 'package:notion_db_sdk/src/module/data/models/property_variants/number_model.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/number.dart';
import 'package:notion_db_sdk/src/module/domain/entity/value.dart';
import 'package:test/test.dart';

void main() {
  group('NumberModel', () {
    test(
      'throws InvalidMapLengthException when map has incorrect structure',
      () {
        final _map = {
          'Quantity': {
            'id': '123',
            'type': 'number',
          },
          'Quantity 1': {
            'id': '123',
            'type': 'number',
          },
        };
        expect(
          () => NumberModel.fromMap(_map),
          throwsA(isA<InvalidMapLengthException>()),
        );
      },
    );

    test(
      'throws InvalidPropertyTypeException with correct expectedType when property type is invalid',
      () {
        final _map = {
          'Quantity': {
            'id': '123',
            'type': 'string', // Intentionally incorrect type
            'value': 42,
          },
        };
        expect(
          () async {
            try {
              NumberModel.fromMap(_map);
            } catch (e) {
              if (e is InvalidPropertyTypeException) {
                expect(e.expectedType, 'number');
                rethrow;
              }
            }
          },
          throwsA(isA<InvalidPropertyTypeException>()),
        );
      },
    );

    test(
      'converts json to number property variant correctly',
      () {
        final _map = {
          'Quantity': {
            'id': '123',
            'type': 'number',
            'number': 42,
          },
        };
        final _number = NumberModel.fromMap(_map);
        const _expectedResult = Number(
          name: 'Quantity',
          type: 'number',
          id: '123',
          valueDetails: Value(value: 42),
        );
        expect(_number, isA<Number>());
        expect(_number, equals(_expectedResult));
      },
    );
  });
}

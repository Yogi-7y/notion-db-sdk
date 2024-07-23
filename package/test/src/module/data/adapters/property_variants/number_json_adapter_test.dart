import 'package:package/src/core/errors/exception.dart';
import 'package:package/src/module/data/adapters/property_variants/number_json_adapter.dart';
import 'package:package/src/module/domain/entity/property_variants/number.dart';
import 'package:package/src/module/domain/entity/value.dart';
import 'package:test/test.dart';

void main() {
  group('NumberJsonAdapter', () {
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
          () => NumberJsonAdapter.fromMap(_map),
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
              NumberJsonAdapter.fromMap(_map);
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
        final _number = NumberJsonAdapter.fromMap(_map);
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

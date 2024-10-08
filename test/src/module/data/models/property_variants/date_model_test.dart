import 'package:notion_db_sdk/src/core/errors/exception.dart';
import 'package:notion_db_sdk/src/module/data/models/property_variants/date_model.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/date.dart';
import 'package:notion_db_sdk/src/module/domain/entity/value.dart';
import 'package:test/test.dart';

void main() {
  group('DateModel Tests', () {
    test(
      'throws InvalidMapLengthException when map has more than 1 key',
      () {
        final _map = {
          'Due date': {
            'id': 'M%3BBw',
            'type': 'date',
            'date': {
              'start': '2023-02-07',
            },
          },
          'Another date': {
            'id': 'M%3BBx',
            'type': 'date',
            'date': {
              'start': '2023-02-08',
            },
          },
        };
        expect(
          () => DateModel.fromMap(_map),
          throwsA(isA<InvalidMapLengthException>()),
        );
      },
    );

    test(
      'throws InvalidPropertyTypeException with correct expectedType when property type is invalid',
      () {
        final _map = {
          'Due date': {
            'id': 'M%3BBw',
            'type': 'invalid_type', // Intentionally incorrect type
            'date': {
              'start': '2023-02-07',
            },
          },
        };
        expect(
          () async {
            try {
              DateModel.fromMap(_map);
            } catch (e) {
              if (e is InvalidPropertyTypeException) {
                expect(e.expectedType, 'date');
                rethrow;
              }
            }
          },
          throwsA(isA<InvalidPropertyTypeException>()),
        );
      },
    );

    test(
      'convert json to date object successfully',
      () {
        final _map = {
          'Due date': {
            'id': 'M%3BBw',
            'type': 'date',
            'date': {
              'start': '2023-02-07',
            },
          },
        };
        final _date = DateModel.fromMap(_map);
        final _expectedResult = Date(
          name: 'Due date',
          id: 'M%3BBw',
          valueDetails: Value(value: DateTime.parse('2023-02-07')),
        );

        expect(_date, isA<Date>());
        expect(_date, equals(_expectedResult));
      },
    );
  });
}

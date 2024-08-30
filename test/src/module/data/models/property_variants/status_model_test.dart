import 'package:notion_db_sdk/src/core/errors/exception.dart';
import 'package:notion_db_sdk/src/module/data/models/property_variants/status_model.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/status.dart';
import 'package:test/test.dart';

void main() {
  group('StatusModel', () {
    test('successfully parses valid JSON data', () {
      final map = {
        'Status': {
          'id': '%40SVO',
          'type': 'status',
          'status': {
            'id': 'c3862971-d624-4a31-a450-b77142035dbc',
            'name': 'Not started',
          }
        }
      };

      final status = StatusModel.fromMap(map);

      expect(status, isA<Status>());
      expect(status.name, 'Status');
      expect(status.id, '%40SVO');
      expect(status.type, 'status');
      expect(status.value, 'Not started');
    });

    test('throws InvalidMapLengthException when map has more than one key', () {
      final map = {
        'Status1': {
          'id': '%40SVO',
          'type': 'status',
          'status': {
            'id': 'c3862971-d624-4a31-a450-b77142035dbc',
            'name': 'Not started',
          }
        },
        'Status2': {
          'id': '%40SVO',
          'type': 'status',
          'status': {
            'id': 'c3862971-d624-4a31-a450-b77142035dbc',
            'name': 'In progress',
          }
        }
      };

      expect(() => StatusModel.fromMap(map), throwsA(isA<InvalidMapLengthException>()));
    });

    test('throws InvalidPropertyTypeException when property type is invalid', () {
      final map = {
        'Status': {
          'id': '%40SVO',
          'type': 'invalid_type',
          'status': {
            'id': 'c3862971-d624-4a31-a450-b77142035dbc',
            'name': 'Not started',
          }
        }
      };

      expect(() => StatusModel.fromMap(map), throwsA(isA<InvalidPropertyTypeException>()));
    });
  });
}

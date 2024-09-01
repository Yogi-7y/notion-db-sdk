import 'package:notion_db_sdk/src/core/errors/exception.dart';
import 'package:notion_db_sdk/src/module/data/models/property_variants/created_time_model.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/created_time.dart';
import 'package:test/test.dart';

void main() {
  group('CreatedTimeModel', () {
    test('successfully creates CreatedTimeModel from valid map', () {
      final map = {
        'Created At': {
          'id': 'abc123',
          'type': 'created_time',
          'created_time': '2023-05-01T10:00:00.000Z',
        }
      };

      final model = CreatedTimeModel.fromMap(map);

      expect(model, isA<CreatedTime>());
      expect(model.name, 'Created At');
      expect(model.id, 'abc123');
      expect(model.type, 'created_time');
      expect(model.value, DateTime.parse('2023-05-01T10:00:00.000Z'));
    });

    test('throws InvalidPropertyTypeException when type is incorrect', () {
      final map = {
        'Created At': {
          'id': 'abc123',
          'type': 'invalid_type',
          'created_time': '2023-05-01T10:00:00.000Z',
        }
      };

      expect(() => CreatedTimeModel.fromMap(map), throwsA(isA<InvalidPropertyTypeException>()));
    });
  });
}

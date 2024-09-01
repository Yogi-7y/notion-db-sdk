import 'package:notion_db_sdk/src/core/errors/exception.dart';
import 'package:notion_db_sdk/src/module/data/models/property_variants/last_edited_time_model.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/last_edited_time.dart';
import 'package:test/test.dart';

void main() {
  group('LastEditedTimeModel', () {
    test('successfully creates LastEditedTimeModel from valid map', () {
      final map = {
        'Last Edited': {
          'id': 'def456',
          'type': 'last_edited_time',
          'last_edited_time': '2023-05-02T15:30:00.000Z',
        }
      };

      final model = LastEditedTimeModel.fromMap(map);

      expect(model, isA<LastEditedTime>());
      expect(model.name, 'Last Edited');
      expect(model.id, 'def456');
      expect(model.type, 'last_edited_time');
      expect(model.value, DateTime.parse('2023-05-02T15:30:00.000Z'));
    });

    test('throws InvalidPropertyTypeException when type is incorrect', () {
      final map = {
        'Last Edited': {
          'id': 'def456',
          'type': 'invalid_type',
          'last_edited_time': '2023-05-02T15:30:00.000Z',
        }
      };

      expect(() => LastEditedTimeModel.fromMap(map), throwsA(isA<InvalidPropertyTypeException>()));
    });
  });
}

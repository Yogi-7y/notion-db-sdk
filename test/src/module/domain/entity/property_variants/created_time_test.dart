import 'package:notion_db_sdk/src/module/domain/entity/property_variants/created_time.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/last_edited_time.dart';
import 'package:notion_db_sdk/src/module/domain/entity/value.dart';
import 'package:test/test.dart';

void main() {
  group('CreatedTime', () {
    test('successfully generates a map as per the contract', () {
      final expectedMap = <String, Object?>{
        'Created At': {
          'created_time': '2023-05-01T10:00:00.000Z',
        }
      };

      final createdTime = CreatedTime(
        name: 'Created At',
        valueDetails: Value(value: DateTime.parse('2023-05-01T10:00:00.000Z')),
      );

      final map = createdTime.toMap();

      expect(map, expectedMap);
    });
  });

  group('LastEditedTime', () {
    test('successfully generates a map as per the contract', () {
      final expectedMap = <String, Object?>{
        'Last Edited': {
          'last_edited_time': '2023-05-02T15:30:00.000Z',
        }
      };

      final lastEditedTime = LastEditedTime(
        name: 'Last Edited',
        valueDetails: Value(value: DateTime.parse('2023-05-02T15:30:00.000Z')),
      );

      final map = lastEditedTime.toMap();

      expect(map, expectedMap);
    });
  });
}

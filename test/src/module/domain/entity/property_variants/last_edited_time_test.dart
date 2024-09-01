import 'package:notion_db_sdk/notion_db_sdk.dart';
import 'package:test/test.dart';

void main() {
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

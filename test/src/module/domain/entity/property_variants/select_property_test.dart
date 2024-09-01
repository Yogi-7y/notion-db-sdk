import 'package:notion_db_sdk/src/module/domain/entity/property_variants/select_property.dart';
import 'package:notion_db_sdk/src/module/domain/entity/value.dart';
import 'package:test/test.dart';

void main() {
  group('Select', () {
    test('successfully generates a map as per the contract', () {
      const expectedMap = <String, Object?>{
        'Status': {
          'select': {'name': 'In Progress'},
        }
      };

      const select = Select(
        name: 'Status',
        valueDetails: Value(value: 'In Progress'),
      );

      final map = select.toMap();

      expect(map, expectedMap);
    });
  });
}

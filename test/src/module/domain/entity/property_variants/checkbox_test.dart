import 'package:notion_db_sdk/src/module/domain/entity/property_variants/checkbox.dart';
import 'package:notion_db_sdk/src/module/domain/entity/value.dart';
import 'package:test/test.dart';

void main() {
  test(
    'checkbox successfully generates a map as per the contract',
    () {
      const _expectedMap = <String, Object?>{
        'Task completed': {
          'checkbox': true,
        }
      };

      const _checkbox = Checkbox(
        name: 'Task completed',
        valueDetails: Value(value: true),
      );

      final _map = _checkbox.toMap();

      expect(_map, _expectedMap);
    },
  );
}

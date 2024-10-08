import 'package:notion_db_sdk/src/module/domain/entity/property_variants/status.dart';
import 'package:notion_db_sdk/src/module/domain/entity/value.dart';
import 'package:test/test.dart';

void main() {
  test(
    'status property successfully generates a map as per the contract',
    () {
      final _expectedMap = <String, Object?>{
        'Status': {
          'status': {'name': 'In progress'}
        }
      };

      const _status = Status(
        name: 'Status',
        valueDetails: Value(
          value: 'In progress',
        ),
      );

      final _map = _status.toMap();

      expect(_map, _expectedMap);
    },
  );
}

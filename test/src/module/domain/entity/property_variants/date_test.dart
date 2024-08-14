import 'package:notion_db_sdk/src/module/domain/entity/property_variants/date.dart';
import 'package:notion_db_sdk/src/module/domain/entity/value.dart';
import 'package:test/test.dart';

void main() {
  test(
    'date property successfully generates a map as per the contract',
    () {
      final _expectedMap = <String, Object?>{
        'Date': {
          'date': '2021-09-01',
        }
      };

      final _date = Date(
        name: 'Date',
        type: 'date',
        valueDetails: Value(
          value: DateTime(2021, 9),
        ),
      );

      final _map = _date.toMap();

      expect(_map, _expectedMap);
    },
  );
}

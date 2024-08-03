import 'package:notion_db_sdk/src/module/domain/entity/property_variants/number.dart';
import 'package:notion_db_sdk/src/module/domain/entity/value.dart';
import 'package:test/test.dart';

void main() {
  test(
    'number property successfully generates a map as per the contract',
    () {
      final _expectedMap = <String, Object?>{
        'Price': {
          'number': 100,
        }
      };

      const _number = Number(
        name: 'Price',
        type: 'number',
        valueDetails: Value(
          value: 100,
        ),
      );

      final _map = _number.toMap();

      expect(_map, _expectedMap);
    },
  );
}

import 'package:package/src/module/domain/entity/property_variants/status.dart';
import 'package:package/src/module/domain/entity/value.dart';
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
        type: 'status',
        valueDetails: Value(
          value: 'In progress',
        ),
      );

      final _map = _status.toMap();

      expect(_map, _expectedMap);
    },
  );
}

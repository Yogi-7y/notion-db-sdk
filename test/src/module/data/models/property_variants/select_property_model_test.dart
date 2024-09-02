import 'package:notion_db_sdk/src/core/errors/exception.dart';
import 'package:notion_db_sdk/src/module/data/models/property_variants/select_property_model.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/select_property.dart';
import 'package:test/test.dart';

void main() {
  group('SelectModel', () {
    test('successfully creates SelectModel from valid map', () {
      final map = {
        'Status': {
          'id': 'abc123',
          'type': 'select',
          'select': {'name': 'In Progress'},
        }
      };

      final model = SelectModel.fromMap(map);

      expect(model, isA<Select>());
      expect(model.name, 'Status');
      expect(model.id, 'abc123');
      expect(model.type, 'select');
      expect(model.value, 'In Progress');
    });

    test('throws InvalidPropertyTypeException when type is incorrect', () {
      final map = {
        'Status': {
          'id': 'abc123',
          'type': 'invalid_type',
          'select': {'name': 'In Progress'},
        }
      };

      expect(() => SelectModel.fromMap(map), throwsA(isA<InvalidPropertyTypeException>()));
    });
  });
}

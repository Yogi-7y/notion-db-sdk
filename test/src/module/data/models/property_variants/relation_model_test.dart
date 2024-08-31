import 'package:notion_db_sdk/src/core/errors/exception.dart';
import 'package:notion_db_sdk/src/module/data/models/property_variants/relation_model.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/relation.dart';
import 'package:test/test.dart';

void main() {
  group('RelationModel', () {
    test('fromMap creates RelationModel correctly', () {
      final map = {
        'Related Tasks': {
          'id': 'rel-123',
          'type': 'relation',
          'relation': [
            {'id': 'page-1'},
            {'id': 'page-2'},
          ],
        },
      };

      final relationModel = RelationModel.fromMap(map);

      expect(relationModel, isA<RelationProperty>());
      expect(relationModel.name, equals('Related Tasks'));
      expect(relationModel.id, equals('rel-123'));
      expect(relationModel.type, equals('relation'));
      expect(relationModel.value?.length, equals(2));
      expect(relationModel.value?[0].id, equals('page-1'));
      expect(relationModel.value?[1].id, equals('page-2'));
    });

    test('fromMap throws InvalidMapLengthException when map has incorrect structure', () {
      final map = {
        'Task 1': {'id': 'rel-1', 'type': 'relation'},
        'Task 2': {'id': 'rel-2', 'type': 'relation'},
      };

      expect(
        () => RelationModel.fromMap(map),
        throwsA(isA<InvalidMapLengthException>()),
      );
    });

    test('fromMap throws InvalidPropertyTypeException when property type is invalid', () {
      final map = {
        'Related Tasks': {
          'id': 'rel-123',
          'type': 'invalid_type',
          'relation': <Map<String, Object?>>[],
        },
      };

      expect(
        () => RelationModel.fromMap(map),
        throwsA(isA<InvalidPropertyTypeException>()),
      );
    });

    test('fromMap handles empty relation list correctly', () {
      final map = {
        'Related Tasks': {
          'id': 'rel-123',
          'type': 'relation',
          'relation': <Map<String, Object?>>[],
        },
      };

      final relationModel = RelationModel.fromMap(map);

      expect(relationModel.value, isEmpty);
    });
  });
}

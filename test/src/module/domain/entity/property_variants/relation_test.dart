import 'package:notion_db_sdk/src/module/domain/entity/page.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/relation.dart';
import 'package:notion_db_sdk/src/module/domain/entity/value.dart';
import 'package:test/test.dart';

void main() {
  group('RelationProperty', () {
    test('constructor initializes properties correctly', () {
      final relation = RelationProperty(
        name: 'Related Tasks',
        valueDetails: Value(value: [Page(id: 'page-1'), Page(id: 'page-2')]),
      );

      expect(relation.name, equals('Related Tasks'));
      expect(relation.type, equals('relation'));
      expect(relation.value?.length, equals(2));
      expect(relation.value?[0].id, equals('page-1'));
      expect(relation.value?[1].id, equals('page-2'));
    });

    test('toMap generates correct map structure', () {
      final relation = RelationProperty(
        name: 'Related Tasks',
        valueDetails: Value(value: [Page(id: 'page-1'), Page(id: 'page-2')]),
      );

      final map = relation.toMap();

      expect(
        map,
        equals(
          {
            'Related Tasks': {
              'relation': [
                {'id': 'page-1'},
                {'id': 'page-2'},
              ],
            },
          },
        ),
      );
    });

    test('toMap handles null value correctly', () {
      const relation = RelationProperty(
        name: 'Related Tasks',
      );

      final map = relation.toMap();

      expect(
        map,
        equals(
          {
            'Related Tasks': {
              'relation': <Object?>[],
            },
          },
        ),
      );
    });
  });
}

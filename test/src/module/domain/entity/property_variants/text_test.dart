import 'package:notion_db_sdk/src/module/domain/entity/property_variants/text.dart';
import 'package:notion_db_sdk/src/module/domain/entity/value.dart';
import 'package:test/test.dart';

void main() {
  test(
    'text property successfully generates a map as per the contract',
    () {
      final _expectedMap = <String, Object?>{
        'Description': {
          'rich_text': [
            {
              'text': {
                'content': 'foo bar',
              }
            }
          ]
        }
      };

      const _text = TextProperty(
        name: 'Description',
        type: 'rich_text',
        valueDetails: Value(
          value: 'foo bar',
        ),
      );

      final _map = _text.toMap();

      expect(_map, _expectedMap);
    },
  );
  test(
    'text property successfully generates a map as per the contract for title type',
    () {
      final _expectedMap = <String, Object?>{
        'Name': {
          'title': [
            {
              'text': {
                'content': 'foo bar',
              }
            }
          ]
        }
      };

      const _text = TextProperty(
        name: 'Name',
        type: 'rich_text',
        isTitle: true,
        valueDetails: Value(
          value: 'foo bar',
        ),
      );

      final _map = _text.toMap();

      expect(_map, _expectedMap);
    },
  );
}

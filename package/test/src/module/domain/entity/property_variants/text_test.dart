import 'package:package/src/module/domain/entity/property_variants/text.dart';
import 'package:package/src/module/domain/entity/value.dart';
import 'package:test/test.dart';

void main() {
  test(
    'text property successfully generates a map as per the contract',
    () {
      final _expectedMap = <String, Object?>{
        'Description': {
          'rich_text': [
            {
              'type': 'text',
              'text': {'content': 'foo bar'}
            }
          ]
        }
      };

      const _text = Text(
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
}

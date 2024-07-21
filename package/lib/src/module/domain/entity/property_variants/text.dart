import 'package:meta/meta.dart';

import '../property.dart';

@immutable
class Text extends Property<String> {
  const Text({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  static const propertyType = 'rich_text';

  @override
  Map<String, Object?> toMap() => {
        name: {
          type: [
            {
              'type': 'text',
              'text': {'content': value}
            }
          ],
        }
      };
}

import 'package:meta/meta.dart';

import '../property.dart';

@immutable
class TextProperty extends Property<String> {
  const TextProperty({
    required super.name,
    super.type = propertyType,
    this.isTitle = false,
    super.id,
    super.valueDetails,
  });

  /// Set to true if you're updating the title(page name) of the page
  final bool isTitle;

  static const propertyType = 'rich_text';

  @override
  Map<String, Object?> toMap() {
    final _type = isTitle ? 'title' : 'rich_text';
    return {
      name: {
        _type: [
          {
            'text': {
              'content': value,
            }
          }
        ],
      }
    };
  }
}

import 'package:meta/meta.dart';

import '../property.dart';

const _richTextType = 'rich_text';
const _titleType = 'title';

@immutable
class TextProperty extends Property<String> {
  const TextProperty({
    required super.name,
    super.type = _richTextType,
    this.isTitle = false,
    super.id,
    super.valueDetails,
  });

  static const supportedTypes = [_richTextType, _titleType];

  /// Set to true if you're updating the title(page name) of the page
  final bool isTitle;

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

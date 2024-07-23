// ignore_for_file: sort_constructors_first

import '../../../../core/errors/property_validators.dart';
import '../../../domain/entity/property_variants/text.dart';
import '../../../domain/entity/value.dart';

class TextJsonAdapter extends Text {
  const TextJsonAdapter({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  static const String propertyType = 'rich_text';

  factory TextJsonAdapter.fromMap(Map<String, Object?> map) {
    final _metaData = getMetaData<List<Map<String, dynamic>>>(
      map: map,
      validators: [
        MapLengthValidator(),
        PropertyTypeValidator(expectedType: propertyType),
      ],
    );

    final richTextList = _metaData.value ?? [];

    final textContent = richTextList.fold<String>('', (prev, element) {
      final text = element['text'] as Map<String, dynamic>?;
      return prev + (text?['content'] as String? ?? '');
    });

    return TextJsonAdapter(
      name: _metaData.name,
      id: _metaData.id,
      type: _metaData.type,
      valueDetails: Value(value: textContent),
    );
  }
}

// ignore_for_file: sort_constructors_first

import '../../../../core/errors/property_validators.dart';
import '../../../domain/entity/property_variants/text.dart';
import '../../../domain/entity/value.dart';

class TextModel extends Text {
  const TextModel({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  static const String propertyType = 'rich_text';

  factory TextModel.fromMap(Map<String, Object?> map) {
    final _metaData = getMetaData<List<Object?>>(
      map: map,
      validators: [
        MapLengthValidator(),
        PropertyTypeListValidator(expectedTypes: [
          propertyType,
          'title',
        ])
      ],
    );

    final richTextList =
        (_metaData.value as List<dynamic>?)?.map((item) => item as Map<String, Object?>).toList() ??
            [];

    final textContent = richTextList.fold<String>('', (prev, element) {
      final text = element['text'] as Map<String, dynamic>?;
      return prev + (text?['content'] as String? ?? '');
    });

    return TextModel(
      name: _metaData.name,
      id: _metaData.id,
      type: _metaData.type,
      valueDetails: Value(value: textContent),
    );
  }
}

// ignore_for_file: sort_constructors_first

import 'package:core_y/core_y.dart';

import '../../../../../notion_db_sdk.dart';
import '../../../../core/errors/property_validators.dart';

class TextModel extends TextProperty {
  const TextModel({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  factory TextModel.fromMap(Map<String, Object?> map) {
    final validators = [
      MapLengthValidator(),
      PropertyTypeListValidator(expectedTypes: TextProperty.supportedTypes),
    ];

    final isValid = validate(validators, map);

    if (!isValid) {
      throw AppException(
        exception: 'Validation failed',
        stackTrace: StackTrace.current,
      );
    }

    final name = map.keys.first;
    final _data = map[name] as Map<String, Object?>? ?? {};
    final type = _data['type'] as String? ?? '';

    if (type == 'unique_id') {
      final metaData = getPropertyData<Map<String, Object?>>(map: map);

      final prefix = metaData.value?['prefix'] as String?;
      final number = metaData.value?['number'] as int?;

      final id = '${prefix ?? ''}-$number';

      return TextModel(
        name: metaData.name,
        id: metaData.id,
        type: type,
        valueDetails: Value(value: id),
      );
    }

    final _metaData = getPropertyData<List<Object?>>(map: map);

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

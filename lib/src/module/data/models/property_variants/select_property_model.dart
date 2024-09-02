import '../../../../../notion_db_sdk.dart';
import '../../../../core/errors/property_validators.dart';
import '../../../domain/entity/property_variants/select_property.dart';

class SelectModel extends Select {
  const SelectModel({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  factory SelectModel.fromMap(Map<String, Object?> map) {
    final metaData = validateAndGetData<Map<String, Object?>>(
      map: map,
      validators: [
        MapLengthValidator(),
        PropertyTypeListValidator(expectedTypes: Select.supportedTypes),
      ],
    );

    final selectData = metaData.value ?? {};
    final selectName = selectData['name'] as String? ?? '';

    return SelectModel(
      name: metaData.name,
      id: metaData.id,
      type: metaData.type,
      valueDetails: Value(value: selectName),
    );
  }
}

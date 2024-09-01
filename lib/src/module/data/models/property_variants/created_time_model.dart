import '../../../../../notion_db_sdk.dart';
import '../../../../core/errors/property_validators.dart';
import '../../../domain/entity/property_variants/created_time.dart';

class CreatedTimeModel extends CreatedTime {
  const CreatedTimeModel({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  factory CreatedTimeModel.fromMap(Map<String, Object?> map) {
    final metaData = validateAndGetData<String>(
      map: map,
      validators: [
        MapLengthValidator(),
        PropertyTypeListValidator(expectedTypes: CreatedTime.supportedTypes)
      ],
    );

    return CreatedTimeModel(
      name: metaData.name,
      id: metaData.id,
      type: metaData.type,
      valueDetails: Value(value: DateTime.parse(metaData.value ?? '')),
    );
  }
}

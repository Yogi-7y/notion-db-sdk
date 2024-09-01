import '../../../../../notion_db_sdk.dart';
import '../../../../core/errors/property_validators.dart';
import '../../../domain/entity/property_variants/last_edited_time.dart';

class LastEditedTimeModel extends LastEditedTime {
  const LastEditedTimeModel({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  factory LastEditedTimeModel.fromMap(Map<String, Object?> map) {
    final metaData = validateAndGetData<String>(
      map: map,
      validators: [
        MapLengthValidator(),
        PropertyTypeListValidator(expectedTypes: LastEditedTime.supportedTypes)
      ],
    );

    return LastEditedTimeModel(
      name: metaData.name,
      id: metaData.id,
      type: metaData.type,
      valueDetails: Value(value: DateTime.parse(metaData.value ?? '')),
    );
  }
}

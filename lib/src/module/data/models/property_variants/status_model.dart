import '../../../../core/errors/property_validators.dart';
import '../../../domain/entity/property_variants/status.dart';
import '../../../domain/entity/value.dart';

class StatusModel extends Status {
  const StatusModel({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  factory StatusModel.fromMap(Map<String, Object?> map) {
    final metaData = validateAndGetData<Map<String, Object?>>(
      map: map,
      validators: [
        MapLengthValidator(),
        PropertyTypeListValidator(expectedTypes: Status.supportedTypes),
      ],
    );

    final statusData = metaData.value ?? {};
    final statusName = statusData['name'] as String? ?? '';

    return StatusModel(
      name: metaData.name,
      id: metaData.id,
      type: metaData.type,
      valueDetails: Value(value: statusName),
    );
  }
}

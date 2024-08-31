import '../../../../core/errors/property_validators.dart';
import '../../../domain/entity/property_variants/date.dart';
import '../../../domain/entity/value.dart';

class DateModel extends Date {
  const DateModel({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  factory DateModel.fromMap(Map<String, Object?> map) {
    final _metaData = validateAndGetData<Map<String, Object?>>(
      map: map,
      validators: [
        MapLengthValidator(),
        PropertyTypeListValidator(expectedTypes: Date.supportedTypes),
      ],
    );

    final _dateInString = (_metaData.value ?? {})['start'] as String?;
    final _date = _dateInString != null ? DateTime.parse(_dateInString) : null;

    return DateModel(
      name: _metaData.name,
      id: _metaData.id,
      type: _metaData.type,
      valueDetails: Value(value: _date),
    );
  }
}

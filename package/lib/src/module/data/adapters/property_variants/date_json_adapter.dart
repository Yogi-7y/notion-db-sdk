import '../../../../core/errors/property_validators.dart';
import '../../../domain/entity/property_variants/date.dart';
import '../../../domain/entity/value.dart';

class DateJsonAdapter extends Date {
  const DateJsonAdapter({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  factory DateJsonAdapter.fromMap(Map<String, Object?> map) {
    final _metaData = getMetaData<Map<String, Object?>>(
      map: map,
      validators: [
        MapLengthValidator(),
        PropertyTypeValidator(expectedType: Date.propertyType),
      ],
    );

    final _dateInString = (_metaData.value ?? {})['start'] as String?;
    final _date = _dateInString != null ? DateTime.parse(_dateInString) : null;

    return DateJsonAdapter(
      name: _metaData.name,
      id: _metaData.id,
      type: _metaData.type,
      valueDetails: Value(value: _date),
    );
  }
}

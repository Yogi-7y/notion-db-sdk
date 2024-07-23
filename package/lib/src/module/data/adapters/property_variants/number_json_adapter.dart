import '../../../../core/errors/property_validators.dart';
import '../../../domain/entity/property_variants/number.dart';
import '../../../domain/entity/value.dart';

class NumberJsonAdapter extends Number {
  const NumberJsonAdapter({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  factory NumberJsonAdapter.fromMap(Map<String, Object?> map) {
    final _metaData = getMetaData<num>(
      map: map,
      validators: [
        MapLengthValidator(),
        PropertyTypeValidator(expectedType: Number.propertyType),
      ],
    );
    return NumberJsonAdapter(
      name: _metaData.name,
      id: _metaData.id,
      type: _metaData.type,
      valueDetails: Value(value: _metaData.value),
    );
  }
}

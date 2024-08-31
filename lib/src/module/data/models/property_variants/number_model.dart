import '../../../../core/errors/property_validators.dart';
import '../../../domain/entity/property_variants/number.dart';
import '../../../domain/entity/value.dart';

class NumberModel extends Number {
  const NumberModel({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  factory NumberModel.fromMap(Map<String, Object?> map) {
    final _metaData = validateAndGetData<num>(
      map: map,
      validators: [
        MapLengthValidator(),
        PropertyTypeListValidator(expectedTypes: Number.supportedTypes),
      ],
    );
    return NumberModel(
      name: _metaData.name,
      id: _metaData.id,
      type: _metaData.type,
      valueDetails: Value(value: _metaData.value),
    );
  }
}

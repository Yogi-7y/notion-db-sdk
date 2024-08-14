import '../../../../core/errors/property_validators.dart';
import '../../../domain/entity/property_variants/phone_number.dart';
import '../../../domain/entity/value.dart';

class PhoneNumberModel extends PhoneNumber {
  const PhoneNumberModel({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  factory PhoneNumberModel.fromMap(Map<String, Object?> map) {
    final _metaData = getMetaData<String>(
      map: map,
      validators: [
        MapLengthValidator(),
        PropertyTypeValidator(expectedType: PhoneNumber.propertyType),
      ],
    );

    return PhoneNumberModel(
      name: _metaData.name,
      id: _metaData.id,
      type: _metaData.type,
      valueDetails: Value(value: _metaData.value),
    );
  }
}

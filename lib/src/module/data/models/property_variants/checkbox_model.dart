import '../../../../core/errors/property_validators.dart';
import '../../../domain/entity/property_variants/checkbox.dart';
import '../../../domain/entity/value.dart';

class CheckboxModel extends CheckboxProperty {
  const CheckboxModel({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  factory CheckboxModel.fromMap(Map<String, Object?> map) {
    final _metaData = validateAndGetData<bool>(
      map: map,
      validators: [
        MapLengthValidator(),
        PropertyTypeListValidator(expectedTypes: CheckboxProperty.supportedTypes),
      ],
    );

    return CheckboxModel(
      name: _metaData.name,
      id: _metaData.id,
      type: _metaData.type,
      valueDetails: Value(value: _metaData.value),
    );
  }
}

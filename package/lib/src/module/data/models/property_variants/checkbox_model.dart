import '../../../../core/errors/property_validators.dart';
import '../../../domain/entity/property_variants/checkbox.dart';
import '../../../domain/entity/value.dart';

class CheckboxModel extends Checkbox {
  const CheckboxModel({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  factory CheckboxModel.fromMap(Map<String, Object?> map) {
    final _metaData = getMetaData<bool>(
      map: map,
      validators: [
        MapLengthValidator(),
        PropertyTypeValidator(expectedType: Checkbox.propertyType),
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

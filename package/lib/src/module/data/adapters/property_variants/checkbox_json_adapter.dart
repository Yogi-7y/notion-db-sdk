import '../../../../core/errors/property_validators.dart';
import '../../../domain/entity/property_variants/checkbox.dart';
import '../../../domain/entity/value.dart';

class CheckboxJsonAdapter extends Checkbox {
  const CheckboxJsonAdapter({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  factory CheckboxJsonAdapter.fromMap(Map<String, Object?> map) {
    final _metaData = getMetaData<bool>(
      map: map,
      validators: [
        MapLengthValidator(),
        PropertyTypeValidator(expectedType: Checkbox.propertyType),
      ],
    );

    return CheckboxJsonAdapter(
      name: _metaData.name,
      id: _metaData.id,
      type: _metaData.type,
      valueDetails: Value(value: _metaData.value),
    );
  }
}

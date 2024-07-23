import '../../../../core/errors/exception.dart';
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
    if (map.length != 1) throw InvalidMapLengthException(map: map);

    final _name = map.keys.first;
    final _data = map[_name] as Map<String, Object?>? ?? {};

    final _id = _data['id'] as String?;
    final _type = _data['type'] as String?;
    final _value = _data['checkbox'] as bool?;

    if (_type == null || _type != Checkbox.propertyType)
      throw InvalidPropertyTypeException(
        map: map,
        expectedType: Checkbox.propertyType,
      );

    return CheckboxJsonAdapter(
      name: _name,
      id: _id,
      type: _type,
      valueDetails: Value(value: _value),
    );
  }
}

import 'package:core_y/core_y.dart';

import '../../domain/entity/property.dart';
import 'property_variants/checkbox_model.dart';
import 'property_variants/date_model.dart';
import 'property_variants/number_model.dart';
import 'property_variants/phone_number_model.dart';
import 'property_variants/text_model.dart';

class PropertyFactory {
  Property call(Map<String, Object?> map) {
    if (map.length != 1)
      throw SerializationException(
        exception: 'Map length must be 1',
        stackTrace: StackTrace.current,
        payload: map,
        code: SerializationExceptionCode.other,
      );

    final propertyData = map.values.first as Map<String, Object?>? ?? {};

    final _type = propertyData['type'];

    if (_type is! String)
      throw SerializationException(
        exception: 'Property type must be a string',
        stackTrace: StackTrace.current,
        payload: map,
        code: SerializationExceptionCode.invalidType,
      );

    switch (_type) {
      case 'rich_text':
      case 'title':
        return TextModel.fromMap(map);
      case 'number':
        return NumberModel.fromMap(map);
      case 'checkbox':
        return CheckboxModel.fromMap(map);
      case 'date':
        return DateModel.fromMap(map);
      case 'phone_number':
        return PhoneNumberModel.fromMap(map);
      default:
        throw UnsupportedError('Unsupported property type: $_type');
    }
  }
}

import '../../domain/entity/property.dart';
import 'property_variants/checkbox_model.dart';
import 'property_variants/date_model.dart';
import 'property_variants/number_model.dart';
import 'property_variants/phone_number_model.dart';
import 'property_variants/text_model.dart';

class PropertyFactory {
  Property call(Map<String, dynamic> map) {
    if (map.isEmpty) {
      throw ArgumentError('Map cannot be empty');
    }

    final propertyData = map.values.first as Map<String, dynamic>;
    final type = propertyData['type'] as String;

    switch (type) {
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
        throw UnsupportedError('Unsupported property type: $type');
    }
  }
}

import 'package:meta/meta.dart';

import '../property.dart';

const _checkboxType = 'checkbox';
const _booleanType = 'boolean';

@immutable
class CheckboxProperty extends Property<bool> {
  const CheckboxProperty({
    required super.name,
    super.type = _checkboxType,
    super.valueDetails,
    super.id,
  });

  static const supportedTypes = [_checkboxType, _booleanType];

  @override
  Map<String, Object?> toMap() {
    return {
      name: {
        type: value,
      }
    };
  }
}

import 'package:meta/meta.dart';

import '../property.dart';

const _selectType = 'select';

@immutable
class Select extends Property<String> {
  const Select({
    required super.name,
    super.type = _selectType,
    super.id,
    super.valueDetails,
  });

  static const supportedTypes = [_selectType];

  @override
  Map<String, Object?> toMap() => {
        name: {
          'select': {'name': value},
        }
      };
}

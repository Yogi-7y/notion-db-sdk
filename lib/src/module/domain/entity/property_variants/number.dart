import 'package:meta/meta.dart';

import '../property.dart';

const _numberType = 'number';

@immutable
class Number extends Property<num> {
  const Number({
    required super.name,
    super.type = _numberType,
    super.valueDetails,
    super.id,
  });

  static const supportedTypes = [_numberType];

  @override
  Map<String, Object?> toMap() => {
        name: {
          'number': value,
        }
      };
}

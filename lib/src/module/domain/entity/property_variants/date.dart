import 'package:meta/meta.dart';

import '../property.dart';

const _dateType = 'date';

@immutable
class Date extends Property<DateTime> {
  const Date({
    required super.name,
    super.type = _dateType,
    super.id,
    super.valueDetails,
  });

  static const supportedTypes = [_dateType];

  String get formattedDate => value?.toIso8601String().split('T').first ?? '';

  @override
  Map<String, Object?> toMap() => {
        name: {
          type: formattedDate,
        }
      };
}

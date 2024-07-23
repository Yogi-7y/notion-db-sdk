import 'package:meta/meta.dart';

import '../property.dart';

@immutable
class Date extends Property<DateTime> {
  const Date({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  static const propertyType = 'date';

  String get _formattedDate => value?.toIso8601String().split('T').first ?? '';

  @override
  Map<String, Object?> toMap() => {
        name: {
          'date': _formattedDate,
        }
      };
}

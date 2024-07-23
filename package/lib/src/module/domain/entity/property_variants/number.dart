import 'package:meta/meta.dart';

import '../property.dart';

@immutable
class Number extends Property<num> {
  const Number({
    required super.name,
    required super.type,
    super.valueDetails,
    super.id,
  });

  @override
  Map<String, Object?> toMap() => {
        name: {
          'number': value,
        }
      };
}

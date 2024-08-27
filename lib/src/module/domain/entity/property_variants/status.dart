import 'package:meta/meta.dart';

import '../property.dart';

@immutable
class Status extends Property<String> {
  const Status({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  static const propertyType = 'status';

  @override
  Map<String, Object?> toMap() => {
        'Status': {
          'status': {'name': value},
        }
      };
}

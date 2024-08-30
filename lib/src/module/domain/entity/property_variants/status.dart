import 'package:meta/meta.dart';

import '../property.dart';

const _statusType = 'status';

@immutable
class Status extends Property<String> {
  const Status({
    required super.name,
    super.type = _statusType,
    super.id,
    super.valueDetails,
  });

  static const supportedTypes = [_statusType];

  @override
  Map<String, Object?> toMap() => {
        'Status': {
          'status': {'name': value},
        }
      };
}

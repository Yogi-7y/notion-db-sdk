import 'package:meta/meta.dart';

import '../../../../../notion_db_sdk.dart';

const _lastEditedTimeType = 'last_edited_time';

@immutable
class LastEditedTime extends Date {
  const LastEditedTime({
    required super.name,
    super.id,
    super.valueDetails,
    super.type = _lastEditedTimeType,
  });

  static const supportedTypes = [_lastEditedTimeType];

  @override
  String get formattedDate => value?.toIso8601String() ?? '';
}

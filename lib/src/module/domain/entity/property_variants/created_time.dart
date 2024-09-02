import 'package:meta/meta.dart';

import '../../../../../notion_db_sdk.dart';

const _createdTimeType = 'created_time';

@immutable
class CreatedTime extends Date {
  const CreatedTime({
    required super.name,
    super.id,
    super.valueDetails,
    super.type = _createdTimeType,
  });

  static const supportedTypes = [_createdTimeType];

  @override
  String get formattedDate => value?.toIso8601String() ?? '';
}

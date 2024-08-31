import 'package:meta/meta.dart';

import '../page.dart';
import '../property.dart';

const _relaiontype = 'relation';

@immutable
class RelationProperty extends Property<List<Page>> {
  const RelationProperty({
    required super.name,
    super.type = _relaiontype,
    super.valueDetails,
    super.id,
  });

  static const supportedTypes = [_relaiontype];

  @override
  Map<String, Object?> toMap() => {
        name: {
          'relation': value?.map((page) => {'id': page.id}).toList() ?? [],
        }
      };
}

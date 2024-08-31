import 'package:meta/meta.dart';
import '../filter.dart';

@immutable
class RelationFilter extends PropertyFilter {
  RelationFilter(
    super.property, {
    this.contains,
    this.doesNotContain,
    this.isEmpty,
    this.isNotEmpty,
  }) : assert(
          [contains, doesNotContain, isEmpty, isNotEmpty].where((v) => v != null).length == 1,
          'Exactly one relation condition must be specified.',
        );

  final String? contains;
  final String? doesNotContain;
  final bool? isEmpty;
  final bool? isNotEmpty;

  @override
  Map<String, dynamic> toMap() => {
        'property': property,
        'relation': {
          if (contains != null) 'contains': contains,
          if (doesNotContain != null) 'does_not_contain': doesNotContain,
          if (isEmpty != null) 'is_empty': isEmpty,
          if (isNotEmpty != null) 'is_not_empty': isNotEmpty,
        },
      };
}

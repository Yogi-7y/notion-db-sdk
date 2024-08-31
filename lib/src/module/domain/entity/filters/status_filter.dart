import 'package:meta/meta.dart';
import '../filter.dart';

@immutable
class StatusFilter extends Filter {
  StatusFilter(
    this.property, {
    this.equals,
    this.doesNotEqual,
    this.isEmpty,
    this.isNotEmpty,
  }) : assert(
          [equals, doesNotEqual, isEmpty, isNotEmpty].where((v) => v != null).length == 1,
          'Exactly one status condition must be specified.',
        );

  final String property;
  final String? equals;
  final String? doesNotEqual;
  final bool? isEmpty;
  final bool? isNotEmpty;

  @override
  Map<String, dynamic> toMap() => {
        'property': property,
        'status': {
          if (equals != null) 'equals': equals,
          if (doesNotEqual != null) 'does_not_equal': doesNotEqual,
          if (isEmpty != null) 'is_empty': isEmpty,
          if (isNotEmpty != null) 'is_not_empty': isNotEmpty,
        },
      };
}

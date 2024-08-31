import 'package:meta/meta.dart';
import '../filter.dart';

@immutable
class PhoneNumberFilter extends PropertyFilter {
  PhoneNumberFilter(
    super.property, {
    this.equals,
    this.doesNotEqual,
    this.contains,
    this.isEmpty,
    this.isNotEmpty,
  }) : assert(
          [equals, doesNotEqual, contains, isEmpty, isNotEmpty].where((v) => v != null).length == 1,
          'Exactly one phone number condition must be specified.',
        );

  final String? equals;
  final String? doesNotEqual;
  final String? contains;
  final bool? isEmpty;
  final bool? isNotEmpty;

  @override
  Map<String, dynamic> toMap() => {
        'property': property,
        'phone_number': {
          if (equals != null) 'equals': equals,
          if (doesNotEqual != null) 'does_not_equal': doesNotEqual,
          if (contains != null) 'contains': contains,
          if (isEmpty != null) 'is_empty': isEmpty,
          if (isNotEmpty != null) 'is_not_empty': isNotEmpty,
        },
      };
}

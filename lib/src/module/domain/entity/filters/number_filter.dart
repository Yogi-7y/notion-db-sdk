import 'package:meta/meta.dart';
import '../filter.dart';

@immutable
class NumberFilter extends FormulaFilter {
  NumberFilter(
    super.property, {
    super.isFormulaProperty,
    this.equals,
    this.doesNotEqual,
    this.greaterThan,
    this.lessThan,
    this.greaterThanOrEqualTo,
    this.lessThanOrEqualTo,
    this.isEmpty,
    this.isNotEmpty,
  }) : assert(
          [
                equals,
                doesNotEqual,
                greaterThan,
                lessThan,
                greaterThanOrEqualTo,
                lessThanOrEqualTo,
                isEmpty,
                isNotEmpty
              ].where((v) => v != null).length ==
              1,
          'Exactly one number condition must be specified.',
        );

  final num? equals;
  final num? doesNotEqual;
  final num? greaterThan;
  final num? lessThan;
  final num? greaterThanOrEqualTo;
  final num? lessThanOrEqualTo;
  final bool? isEmpty;
  final bool? isNotEmpty;

  @override
  Map<String, dynamic> toMapWithoutPropertyKey() => {
        'number': {
          if (equals != null) 'equals': equals,
          if (doesNotEqual != null) 'does_not_equal': doesNotEqual,
          if (greaterThan != null) 'greater_than': greaterThan,
          if (lessThan != null) 'less_than': lessThan,
          if (greaterThanOrEqualTo != null) 'greater_than_or_equal_to': greaterThanOrEqualTo,
          if (lessThanOrEqualTo != null) 'less_than_or_equal_to': lessThanOrEqualTo,
          if (isEmpty != null) 'is_empty': isEmpty,
          if (isNotEmpty != null) 'is_not_empty': isNotEmpty,
        },
      };
}

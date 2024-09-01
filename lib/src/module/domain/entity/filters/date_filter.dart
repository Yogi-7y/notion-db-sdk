import 'package:meta/meta.dart';
import '../filter.dart';

@immutable
class DateFilter extends FormulaFilter {
  DateFilter(
    super.property, {
    super.isFormulaProperty,
    this.equals,
    this.before,
    this.after,
    this.onOrBefore,
    this.onOrAfter,
    this.pastWeek,
    this.pastMonth,
    this.pastYear,
    this.nextWeek,
    this.nextMonth,
    this.nextYear,
    this.isEmpty,
    this.isNotEmpty,
  }) : assert(
          [
                equals,
                before,
                after,
                onOrBefore,
                onOrAfter,
                pastWeek,
                pastMonth,
                pastYear,
                nextWeek,
                nextMonth,
                nextYear,
                isEmpty,
                isNotEmpty
              ].where((v) => v != null).length ==
              1,
          'Exactly one date condition must be specified.',
        );

  final DateTime? equals;
  final DateTime? before;
  final DateTime? after;
  final DateTime? onOrBefore;
  final DateTime? onOrAfter;
  final bool? pastWeek;
  final bool? pastMonth;
  final bool? pastYear;
  final bool? nextWeek;
  final bool? nextMonth;
  final bool? nextYear;
  final bool? isEmpty;
  final bool? isNotEmpty;

  @override
  Map<String, dynamic> toMapWithoutPropertyKey() => {
        'date': {
          if (equals != null) 'equals': equals!.toIso8601String(),
          if (before != null) 'before': before!.toIso8601String(),
          if (after != null) 'after': after!.toIso8601String(),
          if (onOrBefore != null) 'on_or_before': onOrBefore!.toIso8601String(),
          if (onOrAfter != null) 'on_or_after': onOrAfter!.toIso8601String(),
          if (pastWeek != null) 'past_week': <String, Object?>{},
          if (pastMonth != null) 'past_month': <String, Object?>{},
          if (pastYear != null) 'past_year': <String, Object?>{},
          if (nextWeek != null) 'next_week': <String, Object?>{},
          if (nextMonth != null) 'next_month': <String, Object?>{},
          if (nextYear != null) 'next_year': <String, Object?>{},
          if (isEmpty != null) 'is_empty': isEmpty,
          if (isNotEmpty != null) 'is_not_empty': isNotEmpty,
        },
      };
}

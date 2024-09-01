import 'package:meta/meta.dart';
import '../filter.dart';

@immutable
class TextFilter extends FormulaFilter {
  TextFilter(
    super.property, {
    super.isFormulaProperty,
    this.equals,
    this.doesNotEqual,
    this.contains,
    this.doesNotContain,
    this.startsWith,
    this.endsWith,
    this.isEmpty,
    this.isNotEmpty,
  }) : assert(
          [
                equals,
                doesNotEqual,
                contains,
                doesNotContain,
                startsWith,
                endsWith,
                isEmpty,
                isNotEmpty
              ].where((v) => v != null).length ==
              1,
          'Exactly one text condition must be specified.',
        );

  final String? equals;
  final String? doesNotEqual;
  final String? contains;
  final String? doesNotContain;
  final String? startsWith;
  final String? endsWith;
  final bool? isEmpty;
  final bool? isNotEmpty;

  @override
  Map<String, dynamic> toMapWithoutPropertyKey() => {
        'rich_text': {
          if (equals != null) 'equals': equals,
          if (doesNotEqual != null) 'does_not_equal': doesNotEqual,
          if (contains != null) 'contains': contains,
          if (doesNotContain != null) 'does_not_contain': doesNotContain,
          if (startsWith != null) 'starts_with': startsWith,
          if (endsWith != null) 'ends_with': endsWith,
          if (isEmpty != null) 'is_empty': isEmpty,
          if (isNotEmpty != null) 'is_not_empty': isNotEmpty,
        },
      };
}

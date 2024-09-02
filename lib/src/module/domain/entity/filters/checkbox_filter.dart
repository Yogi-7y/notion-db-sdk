import 'package:meta/meta.dart';
import '../filter.dart';

@immutable
class CheckboxFilter extends FormulaFilter {
  CheckboxFilter(
    super.property, {
    this.equals,
    this.doesNotEqual,
    super.isFormulaProperty,
  }) : assert(
          [equals, doesNotEqual].where((v) => v != null).length == 1,
          'Exactly one of equals or doesNotEqual must be specified.',
        );
  final bool? equals;
  final bool? doesNotEqual;

  @override
  Map<String, dynamic> toMapWithoutPropertyKey() {
    return {
      'checkbox': {
        if (equals != null) 'equals': equals,
        if (doesNotEqual != null) 'does_not_equal': doesNotEqual,
      },
    };
  }
}

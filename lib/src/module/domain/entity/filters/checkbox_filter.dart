import 'package:meta/meta.dart';
import '../filter.dart';

@immutable
class CheckboxFilter extends PropertyFilter {
  CheckboxFilter(
    super.property, {
    this.equals,
    this.doesNotEqual,
  }) : assert(
          [equals, doesNotEqual].where((v) => v != null).length == 1,
          'Exactly one of equals or doesNotEqual must be specified.',
        );
  final bool? equals;
  final bool? doesNotEqual;

  @override
  Map<String, dynamic> toMap() => {
        'property': property,
        'checkbox': {
          if (equals != null) 'equals': equals,
          if (doesNotEqual != null) 'does_not_equal': doesNotEqual,
        },
      };
}

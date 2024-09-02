import 'package:meta/meta.dart';

import '../property.dart';

const _peopleType = 'people';

// TODO: Needs implementation
@immutable
class PeopleProperty extends Property<String> {
  const PeopleProperty({
    required super.name,
    super.type = _peopleType,
    super.id,
    super.valueDetails,
  });

  static const supportedTypes = [_peopleType];

  @override
  Map<String, Object?> toMap() {
    throw UnimplementedError();
  }
}

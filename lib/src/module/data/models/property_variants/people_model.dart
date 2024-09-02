import '../../../../../notion_db_sdk.dart';
import '../../../domain/entity/property_variants/people_property.dart';

class PeopleModel extends PeopleProperty {
  const PeopleModel({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  factory PeopleModel.fromMap(Map<String, Object?> map) {
    return PeopleModel(
      name: 'No People',
      type: 'people',
      id: map['id'] as String?,
      valueDetails: const Value(value: 'No People'),
    );
  }
}

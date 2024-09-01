import '../../../../../notion_db_sdk.dart';
import '../../../../core/errors/property_validators.dart';
import '../../../domain/entity/page.dart';
import '../../../domain/entity/property_variants/people.dart';

class PeopleModel extends PeopleProperty {
  const PeopleModel({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  factory PeopleModel.fromMap(Map<String, Object?> map) {
    final metaData = validateAndGetData<List<Object?>>(
      map: map,
      validators: [
        MapLengthValidator(),
        PropertyTypeListValidator(expectedTypes: PeopleProperty.supportedTypes),
      ],
    );

    return PeopleModel(
      name: metaData.name,
      id: metaData.id,
      type: metaData.type,
      valueDetails: const Value(value: ''),
    );
  }
}

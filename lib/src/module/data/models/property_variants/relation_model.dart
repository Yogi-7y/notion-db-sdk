import 'package:meta/meta.dart';

import '../../../../../notion_db_sdk.dart';
import '../../../../core/errors/property_validators.dart';
import '../../../domain/entity/page.dart';
import '../../../domain/entity/property_variants/relation.dart';

@immutable
class RelationModel extends RelationProperty {
  const RelationModel({
    required super.name,
    required super.type,
    super.id,
    super.valueDetails,
  });

  factory RelationModel.fromMap(Map<String, Object?> map) {
    final metaData = validateAndGetData<List<Object?>>(
      map: map,
      validators: [
        MapLengthValidator(),
        PropertyTypeListValidator(expectedTypes: RelationProperty.supportedTypes),
      ],
    );

    final pages = (metaData.value ?? []).map((item) {
      final pageMap = item as Map<String, Object?>? ?? {};
      return Page(id: pageMap['id'] as String? ?? '');
    }).toList();

    return RelationModel(
      name: metaData.name,
      id: metaData.id,
      type: metaData.type,
      valueDetails: Value(value: pages),
    );
  }
}

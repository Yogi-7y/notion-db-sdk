import 'package:core_y/core_y.dart';

import '../../../../notion_db_sdk.dart';
import '../../domain/entity/property.dart';
import '../../domain/entity/property_variants/relation.dart';
import 'property_variants/checkbox_model.dart';
import 'property_variants/date_model.dart';
import 'property_variants/number_model.dart';
import 'property_variants/phone_number_model.dart';
import 'property_variants/relation_model.dart';
import 'property_variants/status_model.dart';
import 'property_variants/text_model.dart';

class PropertyFactory {
  Property call(Map<String, Object?> map) {
    if (map.length != 1)
      throw SerializationException(
        exception: 'Map length must be 1',
        stackTrace: StackTrace.current,
        payload: map,
        code: SerializationExceptionCode.other,
      );

    final propertyData = map.values.first as Map<String, Object?>? ?? {};

    final _type = propertyData['type'];

    if (_type is! String)
      throw SerializationException(
        exception: 'Property type must be a string',
        stackTrace: StackTrace.current,
        payload: map,
        code: SerializationExceptionCode.invalidType,
      );

    if (_type == 'formula') {
      return call(extractPropertyFromFormula(map));
    }

    if (_type == 'rollup') {
      return call(extractPropertyFromRollup(map));
    }

    if (TextProperty.supportedTypes.contains(_type)) return TextModel.fromMap(map);
    if (Number.supportedTypes.contains(_type)) return NumberModel.fromMap(map);
    if (Checkbox.supportedTypes.contains(_type)) return CheckboxModel.fromMap(map);
    if (Date.supportedTypes.contains(_type)) return DateModel.fromMap(map);
    if (PhoneNumber.supportedTypes.contains(_type)) return PhoneNumberModel.fromMap(map);
    if (Status.supportedTypes.contains(_type)) return StatusModel.fromMap(map);
    if (RelationProperty.supportedTypes.contains(_type)) return RelationModel.fromMap(map);

    throw UnsupportedError('Unsupported property type: $_type');
  }

  Map<String, Object?> extractPropertyFromFormula(Map<String, Object?> map) {
    final formulaMap = map.values.first as Map<String, Object?>? ?? {};
    final innerPropertyMap = formulaMap['formula'] as Map<String, Object?>? ?? {};

    final type = innerPropertyMap['type'] as String?;

    if (type == null) {
      throw SerializationException(
        exception: 'Formula inner type is missing',
        stackTrace: StackTrace.current,
        payload: map,
        code: SerializationExceptionCode.invalidType,
      );
    }
    return {
      map.keys.first: {
        'id': formulaMap['id'],
        'type': type,
        type: innerPropertyMap[type],
      },
    };
  }

  Map<String, Object?> extractPropertyFromRollup(Map<String, Object?> map) {
    final rollupMap = map.values.first as Map<String, Object?>? ?? {};
    final innerRollupMap = rollupMap['rollup'] as Map<String, Object?>? ?? {};

    final type = innerRollupMap['type'] as String?;

    if (type == null) {
      throw SerializationException(
        exception: 'Rollup inner type is missing',
        stackTrace: StackTrace.current,
        payload: map,
        code: SerializationExceptionCode.invalidType,
      );
    }

    if (type == 'array') {
      final arrayValue = innerRollupMap['array'] as List<Object?>?;
      if (arrayValue != null && arrayValue.isNotEmpty) {
        final firstArrayItem = arrayValue.first as Map<String, Object?>?;

        if (firstArrayItem != null) {
          final type = firstArrayItem['type'] as String?;

          if (type == null) return <String, Object?>{};

          return <String, Object?>{
            map.keys.first: <String, Object?>{
              'id': rollupMap['id'],
              'type': firstArrayItem['type'],
              type: firstArrayItem[firstArrayItem['type']],
            },
          };
        }
      }
    }

    return <String, Object?>{
      map.keys.first: <String, Object?>{
        'id': rollupMap['id'],
        'type': type,
        type: innerRollupMap[type],
      },
    };
  }
}

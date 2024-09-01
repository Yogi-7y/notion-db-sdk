import 'package:core_y/core_y.dart';

import '../../../../notion_db_sdk.dart';
import '../../domain/entity/property_variants/created_time.dart';
import '../../domain/entity/property_variants/last_edited_time.dart';
import '../../domain/entity/property_variants/people.dart';
import '../../domain/entity/property_variants/select_property.dart';
import 'property_variants/checkbox_model.dart';
import 'property_variants/created_time_model.dart';
import 'property_variants/date_model.dart';
import 'property_variants/last_edited_time_model.dart';
import 'property_variants/number_model.dart';
import 'property_variants/people_model.dart';
import 'property_variants/phone_number_model.dart';
import 'property_variants/relation_model.dart';
import 'property_variants/select_property_model.dart';
import 'property_variants/status_model.dart';
import 'property_variants/text_model.dart';

/// A factory class responsible for creating appropriate [Property] instances
/// based on the raw data received from the Notion API.
class PropertyFactory {
  /// Creates a [Property] instance from a map of raw Notion API data.
  ///
  /// [map] is the raw property data from the Notion API.
  ///
  /// Returns a concrete implementation of [Property] based on the type
  /// of the property in the input map.
  ///
  /// Throws [SerializationException] if the input map is invalid or
  /// the property type is unsupported.
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
    if (CheckboxProperty.supportedTypes.contains(_type)) return CheckboxModel.fromMap(map);
    if (Date.supportedTypes.contains(_type)) return DateModel.fromMap(map);
    if (PhoneNumber.supportedTypes.contains(_type)) return PhoneNumberModel.fromMap(map);
    if (Status.supportedTypes.contains(_type)) return StatusModel.fromMap(map);
    if (RelationProperty.supportedTypes.contains(_type)) return RelationModel.fromMap(map);
    if (CreatedTime.supportedTypes.contains(_type)) return CreatedTimeModel.fromMap(map);
    if (LastEditedTime.supportedTypes.contains(_type)) return LastEditedTimeModel.fromMap(map);
    if (PeopleProperty.supportedTypes.contains(_type)) return PeopleModel.fromMap(map);
    if (Select.supportedTypes.contains(_type)) return SelectModel.fromMap(map);

    throw UnsupportedError('Unsupported property type: $_type for map: $map');
  }

  /// Extracts the underlying property embeded in a formula property. \
  /// Formula does not have a dedicated implementation of [Property] as in the end
  /// it'll be a common type like [TextProperty], [Number], etc.
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

  /// Extracts the underlying property embeded in a rollup property. \
  /// Rollup does not have a dedicated implementation of [Property] as in the end
  /// it'll be a common type like [TextProperty], [Number], etc.
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
      } else {
        return <String, Object?>{
          map.keys.first: <String, Object?>{
            'id': rollupMap['id'],
            'type': 'rich_text',
            type: '',
          },
        };
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

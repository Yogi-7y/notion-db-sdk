import 'package:meta/meta.dart';
import 'package:network_y/network_y.dart';

import '../../../core/network/api_constants.dart';
import '../../domain/entity/property.dart';

class FetchPropertiesRequest extends BaseNotionRequest implements PostRequest {
  FetchPropertiesRequest({
    required this.databaseId,
  }) : super(
          endpoint: 'v1/databases/$databaseId/query',
        );

  final String databaseId;

  @override
  Payload get body => {};
}

@immutable
class CreatePageRequest extends BaseNotionRequest implements PostRequest {
  CreatePageRequest({
    required this.databaseId,
    required this.properties,
  }) : super(
          endpoint: 'v1/pages',
        );

  final String databaseId;
  final List<Property> properties;

  @override
  Payload get body {
    final _properties = <String, Object?>{};

    for (final element in properties) {
      _properties.addAll(element.toMap());
    }

    return {
      'parent': {
        'database_id': databaseId,
      },
      'properties': _properties,
    };
  }
}

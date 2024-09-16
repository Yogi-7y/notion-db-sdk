import 'package:meta/meta.dart';
import 'package:network_y/network_y.dart';
import 'package:network_y/src/pagination/pagination_params.dart';

import '../../../core/network/api_constants.dart';
import '../../domain/entity/filter.dart';
import '../../domain/entity/property.dart';
import '../../domain/repository/notion_repository.dart';
import 'pagable.dart';

class QueryRequest extends BaseNotionRequest implements PostRequest, Pageable {
  QueryRequest({
    required this.databaseId,
    this.filter,
    this.paginationParams,
  }) : super(
          endpoint: 'v1/databases/$databaseId/query',
        );

  final String databaseId;
  final Filter? filter;

  @override
  final CursorPaginationStrategyParams? paginationParams;

  @override
  Payload get body => <String, Object?>{
        if (filter != null) 'filter': filter!.toMap(),
        if (paginationParams != null) ...{
          'start_cursor': paginationParams!.cursor,
          'page_size': paginationParams!.limit,
        }
      };
}

class FetchPagePropertiesRequest extends BaseNotionRequest implements GetRequest {
  FetchPagePropertiesRequest({
    required this.pageId,
  }) : super(
          endpoint: 'v1/pages/$pageId',
        );

  final String pageId;
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

@immutable
class UpdatePagePropertiesRequest extends BaseNotionRequest implements PatchRequest {
  UpdatePagePropertiesRequest({
    required this.pageId,
    required this.properties,
  }) : super(
          endpoint: 'v1/pages/$pageId',
        );

  final PageId pageId;
  final Properties properties;

  @override
  Payload get body {
    final _properties = <String, Object?>{};

    for (final element in properties) {
      _properties.addAll(element.toMap());
    }

    return {
      'properties': _properties,
    };
  }
}

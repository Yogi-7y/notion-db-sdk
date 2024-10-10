import 'package:meta/meta.dart';
import 'package:network_y/network_y.dart';
import 'package:network_y/src/pagination/pagination_params.dart';

import '../../../core/network/api_constants.dart';
import '../../domain/entity/filter.dart';
import '../../domain/entity/property.dart';
import '../../domain/entity/sort/sort.dart';
import '../../domain/repository/notion_repository.dart';
import 'pagable.dart';

class QueryRequest extends BaseNotionRequest implements PostRequest, Pageable {
  QueryRequest({
    required this.databaseId,
    this.filter,
    this.paginationParams,
    this.sorts = const [],
  }) : super(
          endpoint: 'v1/databases/$databaseId/query',
        );

  final String databaseId;
  final Filter? filter;
  final List<Sort> sorts;

  @override
  final CursorPaginationStrategyParams? paginationParams;

  @override
  Payload get body => <String, Object?>{
        if (filter != null) 'filter': filter!.toMap(),
        if (paginationParams?.cursor != null) 'start_cursor': paginationParams!.cursor,
        if (paginationParams?.limit != null) 'page_size': paginationParams!.limit,
        if (sorts.isNotEmpty) 'sorts': sorts.map((e) => e.toMap()).toList(),
      };

  @override
  String toString() {
    final buffer = StringBuffer()
      ..writeln('QueryRequest')
      ..writeln('Database ID: $databaseId')
      ..writeln('Filter: $filter')
      ..writeln('Pagination params: $paginationParams')
      ..writeln('Sorts: $sorts');

    return buffer.toString();
  }
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

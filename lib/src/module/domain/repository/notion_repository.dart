import 'package:core_y/core_y.dart';
// ignore: implementation_imports

import '../entity/property.dart';

typedef Properties = List<Map<String, Property>>;

typedef DatabaseId = String;

abstract class Repository {
  AsyncResult<Properties, AppException> query(
    DatabaseId databaseId,
  );

  AsyncResult<void, AppException> createPage(
    DatabaseId databaseId,
    List<Property> properties,
  );

  AsyncResult<Map<String, Property>, AppException> fetchPageProperties(
    String pageId,
  );
}

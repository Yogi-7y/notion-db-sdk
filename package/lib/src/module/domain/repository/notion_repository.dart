import 'package:core_y/core_y.dart';
// ignore: implementation_imports
import 'package:network_y/src/exceptions/api_exception.dart';

import '../entity/property.dart';

typedef Properties = List<Map<String, Property>>;

typedef DatabaseId = String;

abstract class Repository {
  AsyncResult<Properties, ApiException> getPageProperties(
      DatabaseId databaseId);
}

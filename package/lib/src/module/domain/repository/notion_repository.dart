import 'package:core_y/core_y.dart';

import '../entity/property.dart';

typedef Properties = Map<String, Property>;

typedef DatabaseId = String;

abstract class Repository {
  AsyncResult<Properties, AppException> getProperties(DatabaseId databaseId);
}

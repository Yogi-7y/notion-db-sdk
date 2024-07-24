import '../entity/property.dart';

typedef PageProperties = Map<String, Property>;

typedef DatabaseId = String;

abstract class Repository {
  Future<PageProperties> getPageProperties(DatabaseId databaseId);
}

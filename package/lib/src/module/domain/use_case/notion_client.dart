// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:core_y/core_y.dart';
import 'package:meta/meta.dart';

import '../repository/notion_repository.dart';

class NotionUseCase {
  NotionUseCase({
    required this.options,
    required this.repository,
  });

  final NotionOptions options;
  final Repository repository;

  AsyncResult<Properties, AppException> getProperties(DatabaseId databaseId) {
    return repository.getProperties(databaseId);
  }
}

@immutable
class NotionOptions {
  const NotionOptions({
    required this.secret,
    required this.version,
  });
  final String secret;
  final String version;

  @override
  String toString() => 'NotionOptions(secret: $secret, version: $version)';

  @override
  bool operator ==(covariant NotionOptions other) {
    if (identical(this, other)) return true;

    return other.secret == secret && other.version == version;
  }

  @override
  int get hashCode => secret.hashCode ^ version.hashCode;
}

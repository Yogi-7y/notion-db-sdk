import 'package:core_y/core_y.dart';

import 'property.dart';

abstract class PageResolver {
  AsyncResult<Map<String, Property>, AppException> resolve(String pageId);
}

class Page {
  Page({
    required this.id,
    this.properties = const <String, Property>{},
  });

  final String id;
  Map<String, Property> properties;

  Future<void> resolve(PageResolver resolver) async {
    final result = await resolver.resolve(id);

    result.fold(
      onSuccess: (value) => properties = value,
      onFailure: (error) => throw error,
    );
  }
}

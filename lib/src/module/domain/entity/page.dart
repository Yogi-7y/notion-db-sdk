import 'package:core_y/core_y.dart';

import 'property.dart';

typedef Resolver = AsyncResult<Map<String, Property>, AppException> Function(String);

class Page {
  Page({
    required this.id,
    this.properties = const <String, Property>{},
  });

  final String id;
  Map<String, Property> properties;

  Future<void> resolve(Resolver resolver) async {
    final result = await resolver(id);

    result.fold(
      onSuccess: (value) => properties = value,
      onFailure: (error) => throw error,
    );
  }
}

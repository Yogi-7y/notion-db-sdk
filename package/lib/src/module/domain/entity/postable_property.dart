import 'package:meta/meta.dart';

@immutable
abstract class PostableProperty {
  Map<String, Object?> toMap();
}

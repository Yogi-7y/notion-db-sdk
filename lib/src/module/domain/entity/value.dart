// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:meta/meta.dart';

@immutable
class Value<T> {
  const Value({
    required this.value,
  });

  final T? value;

  @override
  String toString() => 'Value(value: $value)';

  @override
  bool operator ==(covariant Value<T> other) {
    if (identical(this, other)) return true;

    return other.value == value;
  }

  @override
  int get hashCode => value.hashCode;
}

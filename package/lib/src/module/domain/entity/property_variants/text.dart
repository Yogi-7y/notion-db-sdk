import '../property.dart';

class Text extends Property {
  const Text({required super.name, required super.type});

  @override
  Map<String, Object?> toMap() {
    throw UnimplementedError();
  }
}

import 'package:core_y/core_y.dart';
import 'package:mocktail/mocktail.dart';
import 'package:notion_db_sdk/src/module/domain/entity/page.dart';
import 'package:notion_db_sdk/src/module/domain/entity/property_variants/variants.dart';
import 'package:notion_db_sdk/src/module/domain/entity/value.dart';
import 'package:test/test.dart';

class MockPageResolver extends Mock implements PageResolver {}

void main() {
  group('Page', () {
    late Page page;
    late MockPageResolver mockResolver;

    setUp(() {
      page = Page(id: 'test-page-id');
      mockResolver = MockPageResolver();
    });

    test('constructor initializes properties correctly', () {
      expect(page.id, equals('test-page-id'));
      expect(page.properties, isEmpty);
    });

    test('resolve updates properties on success', () async {
      final mockProperties = {
        'title': const TextProperty(name: 'title', valueDetails: Value(value: 'Test Page')),
      };

      when(() => mockResolver.resolve('test-page-id')).thenAnswer(
        (_) async => Success(mockProperties),
      );

      await page.resolve(mockResolver);

      expect(page.properties, equals(mockProperties));
    });

    test('resolve throws error on failure', () async {
      const mockException = AppException(exception: 'Test error', stackTrace: StackTrace.empty);

      when(() => mockResolver.resolve('test-page-id')).thenAnswer(
        (_) async => const Failure(mockException),
      );

      expect(() => page.resolve(mockResolver), throwsA(equals(mockException)));
    });
  });
}

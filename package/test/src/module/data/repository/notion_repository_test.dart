import 'package:mocktail/mocktail.dart';
import 'package:network_y/network_y.dart';
import 'package:package/src/module/data/repository/notion_repository.dart';
import 'package:test/test.dart';

class MockApiClient extends Mock implements ApiClient {}

class FakeGetRequest extends Fake implements GetRequest {}

void main() {
  late NotionRepository repository;
  late MockApiClient apiClient;

  setUpAll(() {
    registerFallbackValue(FakeGetRequest());
  });

  setUp(
    () {
      apiClient = MockApiClient();
      repository = NotionRepository(apiClient);
    },
  );

  group(
    'NotionRepository',
    () {},
  );
}

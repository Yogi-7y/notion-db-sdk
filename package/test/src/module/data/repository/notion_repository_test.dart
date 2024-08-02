// import 'package:core_y/core_y.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:network_y/network_y.dart';
// import 'package:network_y/src/exceptions/api_exception.dart';
// import 'package:package/src/module/data/repository/notion_repository.dart';
// import 'package:test/test.dart';

// class MockApiClient extends Mock implements ApiClient {}

// class FakeGetRequest extends Fake implements GetRequest {}

// void main() {
//   late NotionRepository repository;
//   late MockApiClient apiClient;

//   setUpAll(() {
//     registerFallbackValue(FakeGetRequest());
//   });

//   setUp(
//     () {
//       apiClient = MockApiClient();
//       repository = NotionRepository(apiClient);
//     },
//   );

//   group(
//     'NotionRepository',
//     () {
//       test(
//         'returns success when api call is successful',
//         () async {
//           const _success = Success<Map<String, Object?>, ApiException>(<String, Object?>{});

//           when(
//             () async => apiClient.call<Map<String, Object?>>(any()),
//           ).thenAnswer(
//             (_) => Future.value(_success),
//           );

//           final result = await repository.getPageProperties('databaseId');

//           expect(result, _success);
//         },
//       );
//     },
//   );
// }

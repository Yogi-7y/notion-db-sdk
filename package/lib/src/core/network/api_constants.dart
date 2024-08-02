// ignore: implementation_imports
import 'package:network_y/src/request/request.dart';

class ApiConstants {}

class BaseNotionRequest extends Request {
  BaseNotionRequest({
    required super.endpoint,
    super.baseUrl = 'https://api.notion.com/v1',
  });
}

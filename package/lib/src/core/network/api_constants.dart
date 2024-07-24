import 'package:network_y/network.dart';

class ApiConstants {}

class BaseNotionAPi extends GetRequest {
  const BaseNotionAPi({
    super.host = 'api.notion.com',
    super.endpoint,
  });
}

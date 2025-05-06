import 'package:http/http.dart' as http;

class NetworkService {
  /// Checks if the device is online by making a small request to a reliable server.
  Future<bool> isOnline() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.1.253:3000/stars'))
          .timeout(Duration(seconds: 15));

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {
  dynamic getJson(url) async {
    try {
      http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}

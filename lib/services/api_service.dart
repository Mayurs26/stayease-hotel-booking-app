import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://172.18.248.78:8000/api";

  static Future<List<dynamic>> fetchHotels() async {
    final response = await http.get(Uri.parse("$baseUrl/hotels/"));

    print(response.body); // debug

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load hotels");
    }
  }
}

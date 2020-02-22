import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  final urlUtama = 'https://daki.yiatransport.com/api/v1/';
  static final headers = {"Content-Type": "application/json"};

  Future login(user, password, url) async {
    var data = {
      "email": user,
      "password": password,
    };
    final body = json.encode(data);
    try {
      final response =
          await http.post("$urlUtama$url", headers: headers, body: body);
      final resResult = json.decode(response.body);
      if (resResult['success'] == true) {
        return "Success";
      } else {
        return "Data tidak ditemukan";
      }
    } catch (e) {
      return "Terjadi kesalahan";
    }
  }
}

import 'dart:convert';
import 'package:absensi/models/InfoAbsenModel.dart';
import 'package:absensi/models/userModel.dart';
import 'package:absensi/utils/sharedPref.dart';
import 'package:http/http.dart' as http;
import 'package:absensi/utils/strings.dart';

class ApiServices {
  SharedPref sp = SharedPref();
  
  Future<String> login(user, password, url) async {
    var data = {
      "email": user,
      "password": password,
    };
    final body = json.encode(data);
    try {
      final response =
          await http.post(Strings.urlUtama+"$url", headers: Strings.headers, body: body);
      final resResult = json.decode(response.body);
      if (resResult['success'] == true) {
        UserModel userModel = UserModel.fromJson(resResult['user']);
        sp.setLogin(userModel);
        return "Berhasil Login";
      } else {
        return "Data tidak ditemukan";
      }
    } catch (e) {
      return "Terjadi kesalahan";
    }
  }

  Future<String> getInfoAbsen(empId, tgl, url) async {
    try {
      final response = await http.get(Strings.urlUtama+"$url/$empId/$tgl", headers: Strings.headers);
      final List resResult = json.decode(response.body);
      if (resResult.isEmpty) {
        return "0";
      } else {
        InfoAbsenModel infoAbsenModel = InfoAbsenModel.fromJson(resResult[0]);
        return infoAbsenModel.attendanceCheck;
      }
    } catch (e) {
      return "Terjadi kesalahan";
    }
  }
}

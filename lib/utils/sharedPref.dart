import 'package:absensi/models/userModel.dart';
import 'package:absensi/utils/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  final sp = SharedPreferences.getInstance();

  void setLogin(UserModel data) async {
    final prefs = await sp;
    prefs.setString(Strings.id, data.id);
    prefs.setString(Strings.locationId, data.locationId);
    prefs.setString(Strings.employeeId, data.employeeId);
    prefs.setString(Strings.nik, data.nik);
    prefs.setString(Strings.roleId, data.roleId);
    prefs.setString(Strings.email, data.email);
    prefs.setBool(Strings.isLogin, true);
  }

  dynamic isLogin() async {
    final prefs = await sp;
    return prefs.getBool(Strings.isLogin);
  }

  Future<String> getEmployeedId() async {
    final prefs = await sp;
    return prefs.getString(Strings.employeeId);
  }

  void printSp() async {
    final prefs = await sp;
    print(prefs.getString(Strings.id));
    print(prefs.getString(Strings.locationId));
    print(prefs.getString(Strings.employeeId));
    print(prefs.getString(Strings.nik));
    print(prefs.getString(Strings.roleId));
    print(prefs.getString(Strings.email));
    print(prefs.getBool(Strings.isLogin));
  }

  void destroySp() async {
    final prefs = await sp;
    prefs.clear();
  }
}

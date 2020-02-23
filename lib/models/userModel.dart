class UserModel {
  String id;
  String nik;
  String locationId;
  String employeeId;
  String roleId;
  String email;

  UserModel(this.id, this.nik, this.locationId, this.employeeId, this.roleId,
      this.email);

  UserModel.fromJson(Map<String, dynamic> map):
    id = map['id'],
    nik = map['nik'].toString(),
    locationId = map['location_id'],
    employeeId = map['employee_id'],
    roleId = map['role_id'],
    email = map['emaol'];
}

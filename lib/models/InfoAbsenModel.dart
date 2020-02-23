class InfoAbsenModel {
  final String id;
  final String employeeId;
  final String attendanceCheck;
  final String attendanceInfo;
  final String attendanceLat;
  final String attendanceLong;

  InfoAbsenModel(this.id, this.employeeId, this.attendanceCheck,
      this.attendanceInfo, this.attendanceLat, this.attendanceLong);

  InfoAbsenModel.fromJson(Map<String, dynamic> map)
      : id = map['id'].toString(),
        employeeId = map['employee_id'],
        attendanceCheck = map['attendance_check'],
        attendanceInfo = map['attendance_info'],
        attendanceLat = map['attendance_latitude'],
        attendanceLong = map['attendance_longitude'];
}

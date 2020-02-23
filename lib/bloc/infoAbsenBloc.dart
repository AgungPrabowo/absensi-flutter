import 'package:absensi/utils/apiServices.dart';
import 'package:bloc/bloc.dart';

abstract class InfoAbsenEvent {}

class GetInfoAbsen extends InfoAbsenEvent {
  final String empId;
  final String tgl;

  GetInfoAbsen(this.empId, this.tgl);
}

abstract class InfoAbsenState {}

class InfoAbsen extends InfoAbsenState {
  String absenCheck;

  InfoAbsen(this.absenCheck);
  InfoAbsen copyWith(String absenCheck) => InfoAbsen(absenCheck);
}

class UninitializedInfoAbsen extends InfoAbsenState {}

class InfoAbsenBloc extends Bloc<InfoAbsenEvent, InfoAbsenState> {
  @override
  InfoAbsenState get initialState => UninitializedInfoAbsen();

  @override
  Stream<InfoAbsenState> mapEventToState(InfoAbsenEvent event) async* {
    ApiServices _apiServices = ApiServices();

    if (event is GetInfoAbsen) {
      yield UninitializedInfoAbsen();
      String infoAbsen = await _apiServices.getInfoAbsen(
          event.empId, event.tgl, "attendance/check");
      yield InfoAbsen(infoAbsen);
    }
  }
}

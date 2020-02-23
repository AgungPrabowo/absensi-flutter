import 'package:absensi/bloc/infoAbsenBloc.dart';
import 'package:absensi/utils/sharedPref.dart';
import 'package:absensi/views/login.dart';
import 'package:absensi/views/map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  static String tag = 'home-page';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SharedPref _sp = SharedPref();
  bool _saving = false;
  Position _lastKnownPosition;
  Position _currentPosition;
  bool androidFusedLocation = true;
  InfoAbsenBloc _infoAbsenBloc;
  var currentDate = DateTime.now();

  toast(msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget infoAbsen() {
    return BlocBuilder<InfoAbsenBloc, InfoAbsenState>(
        builder: (context, state) {
      _infoAbsenBloc = BlocProvider.of<InfoAbsenBloc>(context);
      if (state is UninitializedInfoAbsen) {
        return Center(
            child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(),
        ));
      } else {
        InfoAbsen infoAbsen = state as InfoAbsen;
        return Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            infoAbsen.absenCheck,
            style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
                fontSize: 20),
            textAlign: TextAlign.center,
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _initLastKnownLocation();
    _initCurrentLocation();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _lastKnownPosition = null;
      _currentPosition = null;
    });

    _initLastKnownLocation().then((_) => _initCurrentLocation());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initLastKnownLocation() async {
    Position position;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = !androidFusedLocation;
      position = await geolocator.getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.best);
    } on PlatformException {
      position = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _lastKnownPosition = position;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  _initCurrentLocation() {
    Geolocator()
      ..forceAndroidLocationManager = !androidFusedLocation
      ..getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).then((position) {
        if (mounted) {
          setState(() => _currentPosition = position);
        }
      }).catchError((e) {
        //
      });
  }

  currentLocation() {
    print(_currentPosition);
    print(_lastKnownPosition);
  }

  @override
  Widget build(BuildContext context) {
    final body = GestureDetector(
      onTap: () {
        _infoAbsenBloc..add(GetInfoAbsen("5", "2020-02-17"));
      },
      child: Image(
        image: AssetImage('assets/jempol.png'),
        height: 120,
      ),
    );

    final drawer = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[900],
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.map),
            title: Text('Map'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed(Map.tag);
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Daftar Absen'),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              if (!mounted) {
                return;
              }
              setState(() {
                _saving = true;
              });
              _sp.destroySp();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false);
              toast("Anda Berhasil Logout");
              if (!mounted) {
                return;
              }
              setState(() {
                _saving = false;
              });
            },
          ),
        ],
      ),
    );

    return BlocProvider<InfoAbsenBloc>(
      builder: (context) =>
          InfoAbsenBloc()..add(GetInfoAbsen("5", DateFormat("yyyy-MM-dd").format(currentDate))),
      child: ModalProgressHUD(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue[900],
              title: Text(
                'Absensi Mobile',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Center(
                child: ListView(
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              shrinkWrap: true,
              children: <Widget>[body, infoAbsen()],
            )),
            drawer: drawer),
        inAsyncCall: _saving,
      ),
    );
  }
}

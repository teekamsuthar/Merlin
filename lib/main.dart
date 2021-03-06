import 'dart:async';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:merlin/pages/mainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:merlin/pages/home.dart';
import 'services/ad_manager.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Merlin',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: splash_screen(),
    );
  }
}

class splash_screen extends StatefulWidget {
  @override
  _splash_screenState createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  Future<bool> _getOnetimeUse() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('oneTimeUser');
  }

  // Future<void> getLoc() async {
  //   Location location = new Location();
  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;
  //   LocationData _locationData;
  //
  //   _serviceEnabled = await location.serviceEnabled();
  //   if (!_serviceEnabled) {
  //     _serviceEnabled = await location.requestService();
  //     if (!_serviceEnabled) {
  //       return;
  //     }
  //   }
  //
  //   _permissionGranted = await location.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await location.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }
  //
  //   _locationData = await location.getLocation();
  //   globals.lattitude = _locationData.latitude.toString();
  //   globals.longitude = _locationData.longitude.toString();
  //   print(_locationData.latitude.toString());
  //   print(_locationData.longitude.toString());
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bool condition;
    _getOnetimeUse().then((value) {
      condition = value;
    });
    // getLoc();
    Timer(Duration(seconds: 2), () {
      Navigator.pop(context);
      if (condition == true) {
        MaterialPageRoute main =
            new MaterialPageRoute(builder: (context) => mainScreen);
        Navigator.push(context, main);
      } else {
        MaterialPageRoute register =
            new MaterialPageRoute(builder: (context) => registerScreen);
        Navigator.push(context, register);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _initAdMob();
    return Scaffold(
        body: Center(
            child: Image.asset(
      'assets/merlin.png',
      fit: BoxFit.contain,
      height: 100,
    )));
  }
}

Future<void> _initAdMob() {
  //Initialize AdMob SDK
  return FirebaseAdMob.instance.initialize(
    appId: AdManager.appId,
  );
}

MaterialApp registerScreen = new MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(primaryColor: Colors.blue[900]),
  routes: {
    '/': (context) => home_screen(),
  },
);

MaterialApp mainScreen = new MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: ThemeData(primaryColor: Colors.blue[900]),
  routes: {
    '/': (context) => MainPage(),
  },
);

// REDUNDANT CODE

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:http/http.dart' as http;
import 'ad_manager.dart';
import 'database.dart';
import 'globals.dart' as globals;
import 'mainPage.dart';

class EnterAttendanceCode extends StatefulWidget {
  @override
  _EnterAttendanceCodeState createState() => _EnterAttendanceCodeState();
}

class _EnterAttendanceCodeState extends State<EnterAttendanceCode> {
  String qrCodeResult;
  bool useOnce = false;
  Image successWidget = Image.asset(
    'assets/success.gif',
    fit: BoxFit.contain,
  );
  final player = AudioPlayer();
  Map qrJSON;
  bool expiredOrNot = false;
  String responseMsg = "";
  bool successful = false;

  final _codeController = TextEditingController(text: '');

  final GlobalKey<FormState> _codeFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> send() async {
    if (_codeFormKey.currentState.validate()) {
      // send it off to api for validation
      print("sending code for validation: ${_codeController.text}");
      // send and await for response, show ad after success
      await _send().then(
        (_) => {
          // show ad
          if (_isInterstitialAdReady)
            {
              _interstitialAd.show(),
              _loadInterstitialAd(),
            },
        },
      );
    }
  }

  Future<void> _send() async {
    String code = _codeController.text;
    setState(
      () {
        getDatabase().then(
          (value) {
            print('into getDatabase()');
            sendData(value, code).then(
              (value) {
                // Decode all the json response data
                Map<String, dynamic> responseData = jsonDecode(value.body);
                String status = responseData["status"];
                String message = responseData["message"];
                print('Network Request Response: $status : $message');
                // show status based on json response
                if (value.statusCode == 200 && status == "success") {
                  setState(() {
                    successful = true;
                    responseMsg =
                        "Success: " + "Attendance Marked Successfully";
                  });
                  print('Success');
                  playAudio();
                  Fluttertoast.showToast(
                      msg: "Attendance Marked Successfully",
                      toastLength: Toast.LENGTH_LONG);
                } else if (value.statusCode == 200 && status == "error") {
                  setState(() {
                    responseMsg = "Error: " + message;
                    successful = false;
                  });
                  // show ad
                  if (_isInterstitialAdReady) {
                    _interstitialAd.show();
                    _loadInterstitialAd();
                  }
                  Fluttertoast.showToast(
                      msg: "Error: $message", toastLength: Toast.LENGTH_LONG);
                } else {
                  setState(() {
                    successful = false;
                    responseMsg =
                        "Error: Something went wrong, try again later";
                  });
                  // show ad
                  if (_isInterstitialAdReady) {
                    _interstitialAd.show();
                    _loadInterstitialAd();
                  }
                  Fluttertoast.showToast(
                      msg: "Upload Error",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.grey,
                      textColor: Colors.black,
                      fontSize: 16.0);
                }
              },
            );
          },
        );
      },
    );
  }

  Future<void> playAudio() async {
    await player
        .setAsset('assets/audios/success-sound.mp3')
        .then((value) => player.play());
  }

  Future<http.Response> sendData(Map<String, dynamic> input, String code) {
    // encode the details into json to be sent to server api
    var encodedJson = jsonEncode(<String, Object>{
      "uniqueCode": code,
      'studentName': input['student_name'],
      'studentEmail': input['email'],
      'mobileNumber': input['mobile'],
      'latitude': globals.lattitude,
      'longitude': globals.longitude,
      'year': input['year'],
      "department": input['department'],
      "division": input['division'],
      "rollNumber": input['roll_number'],
    });

    //print encoded string in console
    print(encodedJson);

    return http.post(
      'http://vancotech.com/attendance/api/post-scan-code.php',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: encodedJson,
    );
  }

  Future<Map<String, dynamic>> getDatabase() async {
    Map<String, dynamic> data;
    await DBProvider.db.getData(1).then((value) {
      data = value;
    });
    return data;
  }

  BannerAd _bannerAd;

  // Add _interstitialAd
  InterstitialAd _interstitialAd;

  // Add _isInterstitialAdReady
  bool _isInterstitialAdReady;

  // Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    _interstitialAd.load();
  }

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  // Implement _onInterstitialAdEvent()
  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        _isInterstitialAdReady = true;
        break;
      case MobileAdEvent.failedToLoad:
        _isInterstitialAdReady = false;
        print('Failed to load an interstitial ad');
        break;
      case MobileAdEvent.closed:
        break;
      default:
      // do nothing
    }
  }

  @override
  void initState() {
    //implement initState
    successful = false;
    //Initialize _isInterstitialAdReady
    _isInterstitialAdReady = false;
    // Initialize _interstitialAd
    _interstitialAd = InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      listener: _onInterstitialAdEvent,
    );
    // Load an Interstitial Ad
    if (!_isInterstitialAdReady) {
      _loadInterstitialAd();
    }
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.smartBanner,
    );
    // Load a Banner Ad
    _loadBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    //Dispose InterstitialAd object
    _interstitialAd?.dispose();
    _bannerAd?.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Enter Attendance Code'),
      ),
      body: Center(
        child: Form(
          key: _codeFormKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(15, 25, 15, 25),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    responseMsg,
                    style: TextStyle(fontSize: 18),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(15, 35, 15, 35),
                    child: successful ? successWidget : Container(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: (!successful)
                        ? TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Attendance Code',
                              hintText: 'Enter your attendance code....',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue[900]),
                              ),
                            ),
                            controller: _codeController,
                            cursorColor: Colors.blue[900],
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "Please provide a valid input code.";
                              } else {
                                return null;
                              }
                            },
                          )
                        : Container(),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  (!successful)
                      ? FlatButton(
                          onPressed: send,
                          child: Text('   Record My Attendance   '),
                          textColor: Colors.white,
                          height: 45,
                          color: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.all(0.0),
                        )
                      : FlatButton(
                          onPressed: () {
                            dispose();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => mainPage()));
                          },
                          child: Text('  OK  '),
                          textColor: Colors.white,
                          height: 45,
                          color: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.all(0.0),
                        ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

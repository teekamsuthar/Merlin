import 'package:barcode_scan/gen/protos/protos.pb.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:merlin/editProfile.dart';
import 'package:merlin/enter_code.dart';
import 'package:merlin/qrScan.dart';
import 'package:sqflite/sqflite.dart';
import 'package:merlin/database.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'Utils.dart';
import 'ad_manager.dart';

class mainPage extends StatefulWidget {
  @override
  _mainPageState createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  BannerAd _bannerAd;

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  @override
  void initState() {
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.smartBanner,
    );
    // Load a Banner Ad
    _loadBannerAd();
    super.initState();
  }

  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DBProvider.db.getData(1).then((value) => print(value));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        elevation: 5,
        brightness: Brightness.dark,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfile(),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 10, top: 20),
                  child: FaIcon(
                    FontAwesomeIcons.userEdit,
                    size: 40,
                    color: Colors.blue[900],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 30),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                )
              ],
            ),
          ),
          const Divider(
            height: 5,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {
              dispose();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ScanQR(),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 10, top: 20),
                  child: FaIcon(
                    FontAwesomeIcons.qrcode,
                    size: 40,
                    color: Colors.blue[900],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 30, top: 30),
                  child: Text(
                    'Scan QR Code',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                )
              ],
            ),
          ),
          const Divider(
            height: 5,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            color: Colors.grey,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EnterAttendanceCode(),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 10, top: 20),
                  child: FaIcon(
                    FontAwesomeIcons.edit,
                    size: 40,
                    color: Colors.blue[900],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, top: 30),
                  child: Text(
                    'Enter Attendance Code',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                )
              ],
            ),
          ),
          const Divider(
            height: 5,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

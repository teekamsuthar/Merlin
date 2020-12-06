import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:merlin/database.dart';
import 'package:merlin/mainPage.dart';
import 'package:merlin/qrScan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';

import 'Utils.dart';

const pickerData = ['First Year', 'Second Year', 'Third Year', 'Fourth Year'];

class home_screen extends StatefulWidget {
  @override
  _home_screenState createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  TextEditingController your_Name = new TextEditingController();
  TextEditingController college_name = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController mobile_no = new TextEditingController();
  TextEditingController department = new TextEditingController();
  //TextEditingController year_picker = new TextEditingController();
  String year_picker = 'Select Year';
  TextEditingController division = new TextEditingController();
  TextEditingController roll_no = new TextEditingController();
  TextEditingController colleg_no = new TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  //DBProvider database;

  _saveOneTimeUse() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('oneTimeUser', true);
  }

  showPicker(BuildContext context) {
    Picker picker = Picker(
        adapter: PickerDataAdapter<String>(pickerdata: pickerData),
        changeToFirst: false,
        textAlign: TextAlign.left,
        textStyle: const TextStyle(color: Colors.blue),
        selectedTextStyle: TextStyle(color: Colors.red),
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
          setState(() {
            year_picker = picker.getSelectedValues()[0];
          });
        });
    picker.show(_scaffoldKey.currentState);
  }

  TextFormField getTextField(String text, TextEditingController controller,
      FormFieldValidator validator) {
    return TextFormField(
        decoration: InputDecoration(
          labelText: text,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blue[900]),
          ),
        ),
        controller: controller,
        cursorColor: Colors.blue[900],
        // selectionWidthStyle: BoxWidthStyle.tight,
        validator: validator);
  }

  @override
  Widget build(BuildContext context) {
    //WidgetsFlutterBinding.ensureInitialized();
    // if (!year_picker.text.contains('First Year') ||
    //     !year_picker.text.contains('Second Year') ||
    //     !year_picker.text.contains('Third Year') ||
    //     !year_picker.text.contains('Fourth Year')) {
    //   year_picker.text = '';
    // }
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Image.asset(
            'assets/merlin.png',
            fit: BoxFit.contain,
            height: 50,
          ),
          centerTitle: true,
          backgroundColor: Colors.grey[50],
          elevation: 5,
          brightness: Brightness.light,
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Flexible(
                    child: ListView(
                  children: [
                    getTextField(
                        'Student Name', your_Name, Utils.nameValidation),
                    getTextField('College Name', college_name,
                        Utils.collegeNameValidation),
                    getTextField('Email Address', email, Utils.emailValidator),
                    getTextField(
                        'Mobile Number', mobile_no, Utils.validateMobile),
                    getTextField('Department/Specialization', department,
                        Utils.departmentValidation),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        'Select Year',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    FlatButton(
                        onPressed: () {
                          showPicker(context);
                        },
                        child: Text(year_picker),
                        textColor: Colors.black,
                        shape: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        padding: EdgeInsets.all(0.0)),
                    getTextField('Division', division, Utils.generalValidation),
                    getTextField(
                        'Roll Number', roll_no, Utils.rollNumberValidation),
                    getTextField('College Unique Number (Optional)', colleg_no,
                        Utils.collegeNumberValidation),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: FlatButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                print('validating input......');
                              });
                              Map<String, dynamic> addData = {
                                'student_name': your_Name.text,
                                'college_name': college_name.text,
                                'email': email.text,
                                'mobile': mobile_no.text,
                                'department': department.text,
                                'year': year_picker,
                                'division': division.text,
                                'roll_number': roll_no.text,
                                'college_number': colleg_no.text
                              };
                              DBProvider.db.insertData(addData);
                              Navigator.pop(context);
                              _saveOneTimeUse();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => mainPage()));
                            }
                          },
                          child: Text('Save Details'),
                          textColor: Colors.white,
                          color: Colors.blue[900],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          padding: EdgeInsets.all(0.0)),
                    )
                  ],
                )),
              )
            ],
          ),
        ));
  }
}

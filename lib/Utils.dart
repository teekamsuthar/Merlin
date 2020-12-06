import 'package:flutter/material.dart';
import 'package:random_color/random_color.dart';
import 'package:string_validator/string_validator.dart';

class Utils {
  static final Color color = Colors.blue;
  static final errorStyle = TextStyle(color: Colors.red);

  static const BorderRadius borderRadius =
      BorderRadius.all(Radius.circular(15));

  static const Radius radius = Radius.circular(32.0);
  static final borderSide = BorderSide(color: color, width: 1.0);
  static const fillColor = Colors.white;

  static const contentPadding =
      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0);
  static const border = OutlineInputBorder(
    borderRadius: BorderRadius.all(radius),
  );
  static final enabledBorder = OutlineInputBorder(
    borderSide: borderSide,
    borderRadius: BorderRadius.all(radius),
  );
  static final focusedBorder = OutlineInputBorder(
    borderSide: borderSide,
    borderRadius: BorderRadius.all(radius),
  );
  static TextEditingController emailController = TextEditingController();

  static String emailValidator(dynamic value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Please provide a valid email.';
    } else {
      return null;
    }
  }

  static String validateMobile(dynamic value) {
    // String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    // RegExp regExp = new RegExp(pattern);
    // } else if (!regExp.hasMatch(value)) {
    if (value.toString().length != 10 || !isInt(value.toString())) {
      return 'Please enter a valid 10 digit mobile number';
    }
    return null;
  }

  static String generalValidation(dynamic value) {
    if (value.isEmpty) {
      return 'Please provide a valid input';
    }
    return null;
  }

  static String departmentValidation(dynamic value) {
    if (value.isEmpty) {
      return 'Please enter your department/specialization';
    } else if (isInt(value.toString()) || value.toString().length < 2) {
      return 'Please enter your full department name in alphabets only';
    }
    return null;
  }

  static String rollNumberValidation(dynamic value) {
    if (value.toString().isEmpty) {
      return 'Please enter your roll number';
    }
    return null;
  }

  static String collegeNumberValidation(dynamic value) {
    // if (!isInt(value.toString())) {
    //   return 'Please enter your college number';
    // }
    return null;
  }

  static String collegeNameValidation(dynamic value) {
    if (value.isEmpty) {
      return 'Please enter your college name';
    } else if (isInt(value.toString()) || value.toString().length < 5) {
      return 'Please enter your full college name in alphabets only';
    }
    return null;
  }

  static String nameValidation(dynamic value) {
    if (value.isEmpty || value.toString().length <= 4) {
      return 'Please enter your full name';
    } else if (isInt(value.toString())) {
      return 'Name cannot contain numbers';
    }

    return null;
  }

  static String noValidation(dynamic value) {
    return null;
  }

  static Widget emailField = TextFormField(
    autofillHints: [AutofillHints.email],
    controller: emailController,
    keyboardType: TextInputType.emailAddress,
    //textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.email,
        color: Utils.color,
        semanticLabel: 'Email',
      ),
      labelText: "Your Email",
      labelStyle: TextStyle(
        color: Colors.black,
      ),
      errorStyle: Utils.errorStyle,
      filled: true,
      fillColor: Utils.fillColor,
      hintText: "Email",
      contentPadding: Utils.contentPadding,
      border: Utils.border,
      enabledBorder: Utils.enabledBorder,
      focusedBorder: Utils.focusedBorder,
    ),
    validator: emailValidator,
  );
}

import 'dart:convert';
import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:warcash/const.dart';
import 'package:http/http.dart' as http;
import 'package:warcash/home/admin/admin.dart';
import 'package:warcash/home/staff/staff.dart';

class LoginStaff extends StatefulWidget {
  const LoginStaff({Key? key}) : super(key: key);

  @override
  State<LoginStaff> createState() => _LoginStaffState();
}

class _LoginStaffState extends State<LoginStaff> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String secretKey = 'K0s0v@r3Publik';

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<void> loginStaff(context) async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var uri = Uri.parse("https://testdiamondapi.onrender.com/staff/login");
      var res = await http
          .post(
            uri,
            headers: headers,
            body: jsonEncode(<String, String>{
              'email': _email.text,
              'password': _password.text
            }),
          )
          .timeout(const Duration(
              seconds: 10)); // Set an appropriate timeout duration
      var resBody = jsonDecode(res.body);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      if (res.statusCode == 200) {
        print("status code 200 accepted");
        if (resBody['token'] != "" && resBody['token'] != null) {
          log(resBody['token']);
          localStorage.setString("token", resBody['token']);
          localStorage.setString("id", resBody['staff']['_id']);
          localStorage.setBool("isLoggedIn", true);
          localStorage.setString("userName", resBody['staff']['userName']);
          localStorage.setInt("credit", resBody['staff']['credit']);
          localStorage.setInt("role", resBody['staff']['role']);
          if (resBody['staff']['role'] == 2) {
            print("role 2");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Staff()),
              (route) => false,
            );
      }
    }}else{
        print(res.statusCode);
      }
      } catch (e) {
      print("Error during login: $e");
      showErrorMessage(context, "Error during login. Please try again.");
    }
  }
  Future<void> loginAdmin (context) async {
    var headers = {'Content-Type': 'application/json'};
    try {
      var uri = Uri.parse("https://testdiamondapi.onrender.com/admin/login");
      var res = await http
          .post(
        uri,
        headers: headers,
        body: jsonEncode(<String, String>{
          'email': _email.text,
          'password': _password.text
        }),
      )
          .timeout(const Duration(
          seconds: 10));
      print(_email.text);
      print(_password.text);
      var resBody = jsonDecode(res.body);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      if (res.statusCode == 200) {
        print("status code 200 accepted");
        if (resBody['token'] != "" && resBody['token'] != null) {
          log(resBody['token']);
          localStorage.setString("token", resBody['token']);
          localStorage.setString("id", resBody['admin']['_id']);
          localStorage.setBool("isLoggedIn", true);
          localStorage.setString("userName", resBody['admin']['userName']);
          localStorage.setInt("credit", resBody['admin']['credit']);
          localStorage.setInt("role", resBody['admin']['role']);

          if (resBody['admin']['role'] == 1) {
            print("role 1");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Admin()),
                  (route) => false,
            );
          }
        }}else{
        print(res.statusCode);
      }
    } catch (e) {
      print("Error during login: $e");
      showErrorMessage(context, "Error during login. Please try again.");
    }
  }
  void showErrorMessage(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void handleErrorResponse(BuildContext context, Map<String, dynamic> resBody) {
    if (resBody['error'] == 'Incorrect email') {
      showErrorMessage(context, 'Incorrect email');
    } else if (resBody['error'] == 'Incorrect password') {
      showErrorMessage(context, 'Incorrect password');
    } else if (resBody['error'] == 'All fields must be filled!') {
      showErrorMessage(context, 'Please fill all fields!');
    } else if (resBody['error'] == 'Please type in your email!') {
      showErrorMessage(context, 'Please type in your email!');
    } else if (resBody['error'] == 'Please type in your password!') {
      showErrorMessage(context, 'Please type in your password!');
    } else {
      showErrorMessage(context, 'Unexpected error occurred');
    }

    log(resBody.toString());
  }

  bool isObscure = true;
  bool isStaff =true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: size.height * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.3, vertical: size.width * 0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isStaff=true;
                          print(isStaff);

                        });
                      },
                      child: Column(
                        children: [
                           Text(
                            "Staff",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: isStaff?const Color(0xff1A7BC2):Colors.grey[400]),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Container(
                            height: 3,
                            width: size.width * 0.17,
                            color: isStaff?const Color(0xff1A7BC2):Colors.grey[400],
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isStaff=false;
                          print(isStaff);
                        });
                      },
                      child: Column(
                        children: [
                           Text(
                            "Admin",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: !isStaff?const Color(0xff1A7BC2):Colors.grey[400]),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Container(
                            height: 3,
                            width: size.width * 0.17,
                            color:!isStaff?const Color(0xff1A7BC2):Colors.grey[400],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Center(
                child: SizedBox(
                  height: size.height * 0.35,
                  width: size.width * 0.8,
                  child: Image.asset(
                    "assets/transparent_logo.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                child: TextFormField(
                  controller: _email,
                  cursorColor: Colors.black26,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[500]!)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[500]!)),
                      hintText: " Email",
                      hintStyle: TextStyle(color: Colors.grey[700]),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[500]!))),
                ),
              ),
              SizedBox(height: size.height * 0.07),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
                child: TextFormField(
                  controller: _password,
                  cursorColor: Colors.black26,
                  style: const TextStyle(color: Colors.black),
                  obscureText: isObscure,
                  decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                          child: isObscure == true
                              ? const Icon(
                                  Icons.visibility,
                                  color: Colors.black54,
                                )
                              : const Icon(
                                  Icons.visibility_off,
                                  color: Colors.black54,
                                )),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[500]!)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[500]!)),
                      hintText: "Password",
                      hintStyle: const TextStyle(color: Colors.black87),
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[500]!))),
                ),
              ),
              SizedBox(height: size.height * 0.06),
              GestureDetector(
                  onTap: () async {
                    log("entry");
                    await loginStaff(context);
                    log("exit");
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        height: size.height * 0.075,
                        width: size.width * 0.3,
                        decoration: BoxDecoration(
                            color: const Color(0xff1A7BC2),
                            borderRadius: BorderRadius.circular(15)),
                        margin:
                            EdgeInsets.symmetric(horizontal: size.width * 0.04),
                        child: const Center(
                            child: Icon(
                          Icons.arrow_forward,
                          size: 30,
                          color: Colors.white,
                        ))),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

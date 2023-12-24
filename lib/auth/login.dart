import 'dart:convert';
import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:warcash/const.dart';
import 'package:warcash/home/admin/admin.dart';
import 'package:warcash/home/client/client.dart';
import 'package:http/http.dart' as http;
import 'package:warcash/home/staff/staff.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String secretKey = 'K0s0v@r3Publik';

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<void> login(context) async {
    var headers={'Content-Type': 'application/json'};
    try {
      print("try");
      var uri = Uri.parse("https://testdiamondapi.onrender.com/users/login");
      var res = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(<String, String>{
          'email': _email.text,
          'password': _password.text
        }),
      ).timeout(Duration(seconds: 10)); // Set an appropriate timeout duration

      print(uri);
      print("try done");

      var resBody = jsonDecode(res.body);
      print(resBody);
      SharedPreferences localStorage = await SharedPreferences.getInstance();

      if (res.statusCode == 200) {
        print("status code 200 accepted");
        if (resBody['token'] != "" && resBody['token'] != null) {
          log(resBody['token']);
          localStorage.setString("token", resBody['token']);
          localStorage.setString("id", resBody['user']['_id']);
          localStorage.setBool("isLoggedIn", true);
          localStorage.setString("userName", resBody['user']['userName']);
          localStorage.setInt("credit", resBody['user']['credit']);
          localStorage.setInt("role", resBody['user']['role']);
          if(resBody['user']['role']==1){
            print("role 1");
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const Admin()), (route) => false);
          }
          if (resBody['user']['role'] == 2) {
            print("role 2");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Staff()),
                  (route) => false,
            );
          } else if (resBody['user']['role'] == 3) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Client()),
                  (route) => false,
            );
          }
        } else {
          showErrorMessage(context, "Unexpected response from server");
        }
      } else {
        handleErrorResponse(context, resBody);
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
                padding: EdgeInsets.symmetric(horizontal: size.width*0.04,vertical: size.width*0.01),
                child: Column(
                  children: [
                    const Text(
                      "Log in",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600,color: Color(0xff1A7BC2)),
                    ),
                    SizedBox(
                      height: size.height*0.01,
                    ),
                    Container(
                      height: 3,
                      width: size.width*0.17,
                      color: Color(0xff1A7BC2),
                    )
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Center(
                child: SizedBox(
                  height: size.height*0.35,
                  width: size.width*0.8,
                  child: Image.asset("assets/transparent_logo.png",fit: BoxFit.cover,),
                ),
              ),
              SizedBox(height: size.height*0.05),
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
                  onTap: ()async {
                    print("entry");
                    await login(context);
                    print("exit");
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        height: size.height * 0.075,
                        width: size.width*0.3,
                        decoration: BoxDecoration(
                            color: const Color(0xff1A7BC2),
                            borderRadius: BorderRadius.circular(15)),
                        margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
                        child: const Center(
                          child: Icon(Icons.arrow_forward,size: 30,color: Colors.white,)
                        )),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

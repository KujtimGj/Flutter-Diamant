import 'dart:convert';
import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:warcash/const.dart';
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

  Future login(context) async {
    var res = await http.post(Uri.parse("https://testdiamondapi.onrender.com/users/login"),
        headers: <String, String>{
          'Content-Type': 'application/json;charSet=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'email': _email.text,
          'password': _password.text
        }));
    var resBody = jsonDecode(res.body);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (res.statusCode == 200) {
      log("200");
      if (resBody['token'] != "" && resBody['token'] != "") {
        log("-");
        log(resBody['token']);
        log("-");
        localStorage.setString("token", resBody['token']);
        localStorage.setString("id",resBody['user']['_id']);
        localStorage.setBool("isLoggedIn", true);
        localStorage.setString("userName", resBody['user']!['userName']);
        localStorage.setInt("credit", resBody['user']!['credit']);
        localStorage.setInt("role", resBody['user']!['role']);

        if (resBody['user']['role'] == 2) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Staff()),
              (route) => false);
        } else if (resBody['user']['role'] == 3) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const Client()),
              (route) => false);
        }
      } else {
        log("ERROR");
      }
    } else {
      if (resBody['error'] == 'Incorrect email') {
        const snackBar = SnackBar(
          content: Text('Incorrect email'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      if (resBody['error'] == 'Incorrect password') {
        const snackBar = SnackBar(
          content: Text('Incorrect password'),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (resBody['error'] == 'All fields must be filled!') {
        const snackBar = SnackBar(
          content: Text('Please fill all fields!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (resBody['error'] == 'Please type in your email!') {
        const snackBar = SnackBar(
          content: Text('Please type in your email!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (resBody['error'] == 'Please type in your password!') {
        const snackBar = SnackBar(
          content: Text('Please type in your password!'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      log(res.statusCode.toString());
    }
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
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: size.height*0.01,
                    ),
                    Container(
                      height: 3,
                      width: size.width*0.17,
                      color: Colors.black87,
                    )
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                child: const Text("Diamant",style: TextStyle(fontSize: 35,fontWeight: FontWeight.w500),),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width*0.02),
                child: Text("Auto Larje",style: TextStyle(fontSize: 20,color: Colors.grey[700]),),
              ),
              SizedBox(height: size.height*0.15),
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
                  onTap: () {
                    login(context);
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        height: size.height * 0.075,
                        width: size.width*0.3,
                        decoration: BoxDecoration(
                            color: Colors.amber,
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

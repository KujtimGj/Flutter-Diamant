import 'dart:convert';
import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:warcash/core/consts/const.dart';
import 'package:warcash/features/model/userModel.dart';
import 'package:warcash/features/presentation/admin/admin.dart';
import 'package:warcash/features/presentation/client/client.dart';
import 'package:http/http.dart' as http;
import 'package:warcash/features/presentation/staff/staff.dart';
import 'package:warcash/features/providers/ClientAuthProvider.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  String secretKey = 'K0s0v@r3Publik';
  String? uuid;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  Future<void> loginClient(ClientAuthProvider clientAuthProvider) async {
    String email = _email.text.trim();
    String password = _password.text.trim();

    User? client = await clientAuthProvider.loginClient(email, password);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (client != null) {
      print('asd');
      print(client);
      print("Before navigation");
      Navigator.push(context, MaterialPageRoute(builder: (_) => const Client()));
      print("After navigation");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please check your credentials'), backgroundColor: Colors.red,),
      );
    }
  }


  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final clientAuthProvider = Provider.of<ClientAuthProvider>(context);
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
                    await loginClient(clientAuthProvider);
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

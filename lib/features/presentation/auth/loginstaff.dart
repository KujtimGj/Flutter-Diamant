import 'dart:developer';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:warcash/core/consts/const.dart';
import 'package:warcash/features/model/adminModel.dart';
import 'package:warcash/features/model/staffModel.dart';
import 'package:warcash/features/presentation/admin/admin.dart';
import 'package:warcash/features/presentation/staff/staff.dart';
import 'package:warcash/features/providers/StaffAuthProvider.dart';
import 'package:provider/provider.dart';
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
  String? uuid;

  loginStaff(StaffAuthProvider staffProvider)async{
    String email = _email.text.trim();
    String password = _password.text.trim();

    StaffModel? staffModel = await staffProvider.login(email, password);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(staffModel != null){
      Navigator.push(context, MaterialPageRoute(builder: (_)=>const Staff()));
      setState(() {
        uuid=prefs.getString("_id");
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please check your credentials'),backgroundColor: Colors.red,)
      );
    }
  }

  loginAdmin(StaffAuthProvider adminProvider) async{
    String email = _email.text.trim();
    String password = _password.text.trim();

    AdminModel? adminModel = await adminProvider.loginAdmin(email, password);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(adminModel != null){
      Navigator.push(context, MaterialPageRoute(builder: (_)=>const Admin()));
      setState(() {
        uuid=prefs.getString("_id");
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please check your credentials'),backgroundColor: Colors.red,)
      );
    }
  }

  bool isObscure = true;
  bool isStaff =true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final staffProvider = Provider.of<StaffAuthProvider>(context);
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
                            color: isStaff?primaryBlue:Colors.grey[400],
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
                    isStaff?await loginStaff(staffProvider): await loginAdmin(staffProvider);
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

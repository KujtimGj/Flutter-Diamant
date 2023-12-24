import 'package:flutter/material.dart';
import 'package:warcash/auth/login.dart';
import 'package:warcash/auth/loginstaff.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: size.height * 0.6,
                width: size.width,
                child: Image.asset("assets/dcw.png"),
              ),
              SizedBox(height: size.height * 0.1),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const Login()));
                },
                child: Container(
                  height: size.height * 0.07,
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(25)),
                  child: const Center(
                      child: Text(
                    "Login",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  )),
                ),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const LoginStaff()));
                },
                child: Container(
                  height: size.height * 0.07,
                  width: size.width * 0.8,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25)),
                  child: const Center(
                      child: Text(
                    "Continue as staff",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

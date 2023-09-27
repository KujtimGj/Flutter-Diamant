import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcash/auth/login.dart';
import 'package:warcash/home/admin/admin.dart';
import 'package:warcash/home/client/client.dart';
import 'package:warcash/home/staff/staff.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is initialized.
   SharedPreferences prefs = await SharedPreferences.getInstance();
  var isLoggedIn = prefs.getBool("isLoggedIn") ?? false; // Use
  var getRole =prefs.getInt('role')??1;// null-aware operator.
  runApp(MyApp(isLoggedIn: isLoggedIn,role: getRole,));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;
  final int role;

  const MyApp({required this.isLoggedIn, required this.role,Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Widget getHomePage() {
    if (widget.isLoggedIn) {
      if (widget.role == 1) {
        return const Admin();
      } else if(widget.role==2){
        return const Staff();
      }else if(widget.role==3){
        return const Client();
      }else{
        return const Login();
      }
    } else {
      return const Login();
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: getHomePage(),
      // home: Staff(),
    );
  }
}

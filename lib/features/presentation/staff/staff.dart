import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcash/features/presentation/auth/login.dart';
import 'package:warcash/features/presentation/auth/splashscreen.dart';
import 'package:warcash/features/presentation/staff/ballina.dart';
import 'package:warcash/features/presentation/staff/historia.dart';
import 'package:warcash/features/presentation/staff/stats.dart';
import '../../../core/consts/const.dart';

enum SelectedItem { ballina, statistikat, historia }

class Staff extends StatefulWidget {
  const Staff({Key? key}) : super(key: key);

  @override
  State<Staff> createState() => _StaffState();
}

class _StaffState extends State<Staff> {
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  String name = '';
  String qrCode = '';
  int credit = 0;

  getUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      name = localStorage.getString('userName').toString();
      qrCode = localStorage.getString('qrCode').toString();
      credit = int.parse(localStorage.getInt('credit').toString());
    });
  }

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;


  bool cameraOpened = false;
  SelectedItem selected = SelectedItem.ballina;

  logout()async{
    SharedPreferences localStorage = await  SharedPreferences.getInstance();
    localStorage.setBool("isLoggedIn",false);
    localStorage.remove('userName');
    localStorage.remove('credit');
    localStorage.remove('role');
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>const SplashScreen()), (route) => false);

  }
  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text('Are you sure you want to log out?'),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: false,
            onPressed: () {
             logout();
            },
            child:const Text('Yes'),
          ),
        ],
      ),
    );
  }
  void _showAndroidAlert(context){
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => logout(),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              _showAlertDialog(context);
            },
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 20, 0),
              child: Icon(
                Icons.logout,
                color: Colors.black,
                size: 60,
              ),
            ),
          )
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name.toString(),
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: Colors.black),
            ),
            Text(
              "Staff",
              style: TextStyle(color: Colors.grey[600], fontSize: 17),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Divider(color: primaryBlue),
            SizedBox(height: size.height * 0.025),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = SelectedItem.ballina;
                      });
                    },
                    child: Column(
                      children: [
                        const Text("Ballina"),
                        Opacity(
                          opacity: selected == SelectedItem.ballina ? 1.0 : 0,
                          child: Container(
                            height: size.height * 0.02,
                            width: size.width * 0.02,
                            decoration: const BoxDecoration(
                                color: primaryBlue, shape: BoxShape.circle),
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = SelectedItem.statistikat;
                      });
                    },
                    child: Column(
                      children: [
                        const Text("Statistikat"),
                        Opacity(
                          opacity:
                              selected == SelectedItem.statistikat ? 1.0 : 0,
                          child: Container(
                            height: size.height * 0.02,
                            width: size.width * 0.02,
                            decoration: const BoxDecoration(
                                color: primaryBlue, shape: BoxShape.circle),
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selected = SelectedItem.historia;
                      });
                    },
                    child: Column(
                      children: [
                        const Text("Historia"),
                        Opacity(
                          opacity: selected == SelectedItem.historia ? 1.0 : 0,
                          child: Container(
                            height: size.height * 0.02,
                            width: size.width * 0.02,
                            decoration: const BoxDecoration(
                                color: primaryBlue, shape: BoxShape.circle),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: size.height * 0.02),
            SizedBox(height: size.height * 0.03),
            Visibility(
              visible: selected == SelectedItem.ballina,
              child: const Ballina(),
            ),
            Visibility(
              visible: selected == SelectedItem.statistikat,
              child:  Stats(),
            ),
            Visibility(
              visible: selected == SelectedItem.historia,
              child: const Historia(),
            )
            // const Stats(),
          ],
        ),
      ),
    );
  }

}

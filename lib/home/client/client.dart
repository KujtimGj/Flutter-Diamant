import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcash/const.dart';


enum SelectedItem { ballina, statistikat, profili }

class Client extends StatefulWidget {
  const Client({Key? key}) : super(key: key);

  @override
  State<Client> createState() => _ClientState();
}

class _ClientState extends State<Client> {
  // List<ImageProvider>? imageList;
  // bool autoRotate = true;
  // int rotationCount = 2;
  // int swipeSensitivity = 10;
  // bool allowSwipeToRotate = true;
  // Duration frameChangeDuration = const Duration(milliseconds: 50);

  // addImages(BuildContext context) async {
  //   final List<Future<void>> precacheFutures = [];
  //
  //   for (int i = 0; i < 73; i++) {
  //     final imageUrl =
  //         "https://imgd-ct.aeplcdn.com/1280x720/cw/360/mercedesbenz/1023/open-door/$i.jpg?wm=4&q=75&v=20180219023030";
  //
  //     final precacheFuture = precacheImage(CachedNetworkImageProvider(imageUrl), context);
  //     precacheFutures.add(precacheFuture);
  //     print(i);
  //   }
  //
  //   // Wait for all preloading to complete
  //   await Future.wait(precacheFutures);
  //
  //   // After all images are preloaded, update the imageList and trigger a rebuild
  //   setState(() {
  //     imageList = List.generate(70, (i) {
  //       final imageUrl =
  //           "https://imgd-ct.aeplcdn.com/1280x720/cw/360/mercedesbenz/1023/open-door/${i + 1}.jpg?wm=4&q=75&v=20180219023030";
  //       return CachedNetworkImageProvider(imageUrl);
  //     });
  //   });
  // }
  @override
  void initState() {
    getUserData();
    const Duration(seconds: 1);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // addImages(context);
    });
    super.initState();
  }

  String name = '';
  String qrCode = '';
  int credit = 0;

  logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setBool("isLoggedIn", false);
    localStorage.remove("userName");
    localStorage.remove("credit");
  }

  getUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      name = localStorage.getString('userName').toString();
      qrCode = localStorage.getString('qrCode').toString();
      credit = int.parse(localStorage.getInt('credit').toString());
    });
  }


  bool cameraOpened = false;
  SelectedItem selected = SelectedItem.ballina;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          GestureDetector(
            onTap: () {
              // logout();
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (_) => const Login()),
              //     (route) => false);

              setState(() {
                cameraOpened = !cameraOpened;
              });
              print("asd");
            },
            child: const Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 20, 0),
              child: Icon(
                Icons.qr_code,
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
      body: const SingleChildScrollView(
        child: SizedBox(),
      ),
    );
  }


}


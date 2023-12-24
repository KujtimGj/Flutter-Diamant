import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:warcash/features/presentation/auth/login.dart';

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
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => Login()), (route) => false);
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 60,
          elevation: 0,
          backgroundColor: Colors.blue,
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Container(
              height: size.height * 0.17,
              width: size.width,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Miresevini",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      GestureDetector(
                          onTap: () {
                            logout();
                          },
                          child: const Icon(Icons.logout,
                              color: Colors.white, size: 30))
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
              child: Text(
                "Sherbimet",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey[200]),
                        child: const Center(
                          child: Icon(Icons.car_crash_outlined,color: Colors.blue,size: 30,),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Exterior")
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey[200]),
                        child: const Center(
                          child: Icon(Icons.car_crash_outlined,color: Colors.blue,size: 30,),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Interior")
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey[200]),
                        child: const Center(
                          child: Icon(Icons.car_crash_outlined,color: Colors.blue,size: 30,),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Detailing")
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.grey[200]),
                        child: const Center(
                          child: Icon(Icons.car_crash_outlined,color: Colors.blue,size: 30,),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Vacuum")
                    ],
                  ),
                ],
              )
            ),
            SizedBox(height: size.height*0.05),
            Container(
              margin: const EdgeInsets.all(10),
              height: size.height * 0.25,
              width: size.width * 0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.blue),
              padding: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Kreditë: ",
                          style:
                              TextStyle(fontSize: 15, color: Colors.white),
                        ),
                        Text(
                          "24.00$credit",
                          style: const TextStyle(
                              fontSize: 20, color: Colors.white),
                        ),
                        SizedBox(height: 20),
                        Text(
                          name,
                          style: const TextStyle(color: Colors.white, fontSize: 17),
                        ),
                      ],
                    ),
                    QrImageView(
                      data: qrCode,
                      version: QrVersions.auto,
                      size: 110,
                      foregroundColor: Colors.white,
                    ),
                    // Text(credit.toString())
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
              child: Text(
                "Pagesat e me hershme",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  height: 80,
                  width: size.width,
                  child: Row(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(width: 1, color: Colors.grey[500]!)),
                        child: const Center(
                          child: Icon(
                            Icons.attach_money_sharp,
                            color: Colors.blue,
                            size: 30,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Larje brenda jasht",
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            "100 kredi",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                      const SizedBox(width: 30),
                    ],
                  ),
                );
              },
            )
          ],
        ));
  }
}

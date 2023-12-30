import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:warcash/core/consts/const.dart';
import 'package:warcash/core/consts/dimensions.dart';
import 'package:warcash/features/presentation/auth/login.dart';
import 'package:warcash/features/presentation/auth/splashscreen.dart';

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
    localStorage.remove("role");
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => const SplashScreen()), (route) => false);
  }

  List<dynamic> subscriptions=[
    {"name": "Silver","points":50,"color":Colors.grey[500],'price':10,'features':['1 Tyre Cleaning','1 Details Car Wash','1 detailed cleaning']},
    {"name": "Gold","points":70,"color":Colors.amber,'price':20,'features':['1 Tyre Cleaning','1 Details Car Wash','1 detailed cleaning']},
    {"name": "VIP","points":100,"color":darkBlue,'price':30,'features':['1 Tyre Cleaning','1 Details Car Wash','1 detailed cleaning']},
  ];

  List<dynamic> services=[
    {'type':'Exterior','icon':Icons.car_crash_outlined,'image':"assets/images/carwashing.jpg",'title':'Exterior wash','body':"Lorem ipsum"},
  ];

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
          toolbarHeight: 80,
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Mirë se vini",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
              Text(
                name,
                style: const TextStyle(color: primaryBlue),
              )
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                  onTap: () {
                    logout();
                  },
                  child: Icon(Icons.logout,
                      color: primaryBlue.withOpacity(0.5), size: 35)),
            )
          ],
        ),
        body: ListView(
          children: [
            Container(
              height: getPhoneHeight(context) * 0.25,
              width: getPhoneWidth(context) * 0.85,
              margin: EdgeInsets.symmetric(
                  horizontal: getPhoneWidth(context) * 0.035),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: const AssetImage("assets/images/carwashing.jpg"),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(
                          0.7), // Adjust color and opacity as needed
                      BlendMode.overlay, // Adjust blend mode as needed
                    ),
                  )),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Auto Larje",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Express",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
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
                            child: Icon(
                              Icons.car_crash_outlined,
                              color: Colors.blue,
                              size: 30,
                            ),
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
                          child: Center(
                              child: Image.asset(
                            'assets/icons/car-seat.png',
                            height: 30,
                            color: primaryBlue,
                          )),
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
                          child: Center(
                              child: Image.asset(
                            'assets/icons/detail-cleaning.png',
                            color: primaryBlue,
                          )),
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
                          child: Center(
                              child: Image.asset(
                                'assets/icons/vacuum-cleaner-.png',
                                color: primaryBlue,
                              )),
                        ),
                        const SizedBox(height: 10),
                        const Text("Vacuum")
                      ],
                    ),
                  ],
                )),
            SizedBox(height: size.height * 0.05),
            Container(
              margin: const EdgeInsets.all(10),
              height: size.height * 0.25,
              width: size.width * 0.9,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: darkBlue),
              child: Stack(
                children: [
                  Positioned(
                    top:-20,
                    left: -20,
                    child: Container(
                      height:70,
                      width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1)
                      ),
                    ),
                  ),
                  Positioned(
                    top:-20,
                    right: -20,
                    child: Container(
                      height:100,
                      width: 100,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1)
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal:getPhoneWidth(context)*0.05),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Kreditë: ",
                              style: TextStyle(fontSize: 15, color: Colors.white),
                            ),
                            Text(
                              "24.00$credit",
                              style: const TextStyle(
                                  fontSize: 20, color: Colors.white),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 17),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              decoration:BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: const Center(
                                  child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                                child: Text("Rimbush",style: TextStyle(color: Colors.white),),
                              )),
                            )
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
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
              child: Text(
                "Abonimet",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: getPhoneHeight(context)*0.38,
              width: getPhoneWidth(context),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subscriptions.length,
                physics: ClampingScrollPhysics(),
                itemBuilder: (BuildContext context, int index){
                  final isLastItem = index == subscriptions.length - 1;
                  return Container(
                    height: getPhoneHeight(context),
                    width: getPhoneWidth(context)*0.55,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: subscriptions[index]['color'],
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Stack(
                      children: [
                        isLastItem?Stack(
                          children: [
                            Positioned(
                              top:-15,
                              left: -30,
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.3)
                                ),
                              ),
                            ),
                            Positioned(
                              bottom:-10,
                              right: -20,
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.3)
                                ),
                              ),
                            ),
                            Positioned(
                              top:-10,
                              right: -20,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withOpacity(0.3)
                                ),
                              ),
                            )
                          ],
                        ):const SizedBox(),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical:getPhoneHeight(context)*0.03 ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.attach_money_outlined,color: Colors.white,),
                                  Text("Paketa ${subscriptions[index]['name']}",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight:FontWeight.w500),)
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (subscriptions[index]['features'] != null)
                                    for (var feature in subscriptions[index]['features']!)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Text(
                                          '- $feature',
                                          style: TextStyle(color: Colors.white,fontSize: 16),
                                        ),
                                      ),
                                ],
                              ),
                              Center(
                                child: Text(
                                  '${subscriptions[index]['price'].toString()} €',style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w600),),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
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

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/consts/const.dart';

class Ballina extends StatefulWidget {
  const Ballina({Key? key}) : super(key: key);

  @override
  State<Ballina> createState() => _BallinaState();
}

class _BallinaState extends State<Ballina> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? result;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      if (Platform.isAndroid) {
        controller!.pauseCamera();
      } else if (Platform.isIOS) {
        controller!.resumeCamera();
      }
    }
  }

  bool camOpen = false;
  String name = '';
  int credits = 0;
  String subscription = '';
  String email = '';
  String ClientID="";
  String StaffID="";

  getClientByQrCode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      ClientID = prefs.getString('clientID')!;
      name = prefs.getString('clientUserName')!;
      credits = int.parse(prefs.getInt('clientCredit').toString());
      subscription = prefs.getString('clientSubsType')!;
      email = prefs.getString('clientEmail')!;
      StaffID = prefs.getString("id")!;
    });
  }

  confirmService(String ClientID,StaffID,ServiceID,CreditUsed) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    String? token = localStorage.getString('token');
    StaffID = localStorage.getString("id")!;
    String ClientID = localStorage.getString('clientID')!;



    try{
      final response = await http.post(
        Uri.parse('https://testdiamondapi.onrender.com/completedServices'),
        headers: {'Content-Type': 'application/json','Authorization': 'Bearer $token'},
        body: jsonEncode({'ClientID':ClientID, 'StaffID':StaffID ,'ServiceID':selectedItemId,'CreditUsed':selectedItemCost}),
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          var resBody = jsonDecode(response.body);
          log('$response request successfully sent');
          log("$resBody sdaddasds");
          log(ClientID);
        } else {
          log('Response body is empty.');
        }
      } else {
        log('Request failed with status code: ${response.statusCode}');
      }
    }catch(e){
      log(e.toString());
    }
   }

  List<Map<String, dynamic>> items = [];
  String selectedItemId = '';
  String hintText = 'Zgjedh sherbimin';
  int selectedItemCost=0;

  fetchServices()async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? token = localStorage.getString('token');


    final response = await http.get(
        Uri.parse("https://testdiamondapi.onrender.com/services"),
        headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
        },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        items = List<Map<String, dynamic>>.from(data);
      });
    }
  }

  void updateSelectedItem(String? itemId) {
    if (itemId != null) {
      final item = items.firstWhere((item) => item['_id'] == itemId);
      setState(() {
        selectedItem = item;
        selectedItemId = itemId;
        hintText = item['name'];
        selectedItemCost=item['cost'];
        print(selectedItemCost);
        print(selectedItem['name']);
        print(selectedItemId);
      });
    }
  }

  getID() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var idja = preferences.getString("id");
    print(idja);
  }

  Map<String, dynamic> selectedItem = {}; // Holds the selected item

  @override
  void initState() {
    super.initState();
    fetchServices();
    getID();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        camOpen == false
            ? GestureDetector(
                onTap: () {
                  print("entry");
                  setState(() {
                    camOpen = true;
                  });
                  print("Exit");
                },
                child: Icon(
                  Icons.qr_code_2,
                  color: Colors.black,
                  size: size.height * 0.3,
                ))
            : Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        camOpen = !camOpen;
                      });
                    },
                    child: const Text(
                      "Skano kodin",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  SizedBox(
                      height: size.height * 0.3,
                      width: size.width * 0.65,
                      child: QRView(
                        key: qrKey,
                        onQRViewCreated: _onQRViewCreated,
                      )),
                  Center(
                    child: (result != null)
                        ? Column(
                            children: [
                              SelectableText(
                                'Perdoruesi:\n${result!.code}',
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 23),
                                textAlign: TextAlign.center,
                              ),
                              // Text(
                              //   "Barcode Type: ${describeEnum(result!.format)}",
                              //   style: TextStyle(
                              //       color: Colors.grey[600], fontSize: 16),
                              // )
                            ],
                          )
                        : const Text(
                            '',
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ],
              ),
        SizedBox(height: size.height * 0.04),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
          child: SizedBox(
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Klienti",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        Text(
                          name,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 21),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Credits",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        Text(
                          credits.toString(),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 21),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        Text(
                          email,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 18),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Subscription",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        Text(
                          subscription,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 21),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: size.height*0.05),
                Column(
                  children: [
                    const Text("Zgjedh sherbimin",style: TextStyle(fontSize: 20),),
                    SizedBox(height: size.height*0.03),
                    SizedBox(
                      width: size.width,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          isExpanded: true,
                          hint: Text(
                            hintText,
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).hintColor,
                            ),
                          ),
                          items: items.map<DropdownMenuItem<String>>((item) {
                            return DropdownMenuItem<String>(
                              value: item['_id'],
                              child: Text(item['name']),
                            );
                          }).toList(),
                          onChanged: updateSelectedItem,
                          buttonStyleData: const ButtonStyleData(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            height: 40,
                            width: 140,
                          ),
                          menuItemStyleData: const MenuItemStyleData(
                            height: 40,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height*0.03),
                    GestureDetector(
                      onTap: (){
                        confirmService(ClientID, StaffID, selectedItemId,selectedItemCost);
                      },
                      child: Container(
                        height: size.height*0.07,
                        width: size.width*0.85,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: primaryBlue
                        ),
                        child: const Center(
                          child: Text("Konfirmo larjen",style: TextStyle(color: Colors.white,fontSize: 18),),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height*0.05),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    var isScanning = true;

    controller.scannedDataStream.listen((scanData) {
      if (isScanning) {
        setState(() {
          result = scanData;
          log(result.toString());
        });
        findUserById();

        isScanning = false;

        // Pause or stop the scanning stream
        controller
            .pauseCamera();
      }
    });
  }

  findUserById() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    log(localStorage.getString('token').toString());
    log("=======================");
    log(result!.code.toString());
    String? token = localStorage.getString('token');
    log(token.toString());
    if (token != null) {
      token = token.trim();
    }
    if (result != null) {
      final response = await http.get(
        Uri.parse(
            "https://testdiamondapi.onrender.com/users/qrcode/${result!.code}"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      var resBody = jsonDecode(response.body);
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        jsonDecode(response.body);
        log(resBody.toString());
        getClientByQrCode();
        localStorage.setString('clientID', resBody['_id']);
        localStorage.setString('clientUserName', resBody['userName']);
        localStorage.setString('clientSubsType', resBody['subscription']);
        localStorage.setInt('clientCredit', resBody['credit']);
        localStorage.setString('clientEmail', resBody['email']);
      }
    } else {
      log('$result');
    }
  }
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
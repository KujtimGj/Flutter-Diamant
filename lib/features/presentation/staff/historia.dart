import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcash/features/presentation/auth/login.dart';
import 'package:http/http.dart' as http;
import 'package:warcash/core/consts/const.dart';

import '../../model/completedServicesModel.dart';

class Historia extends StatefulWidget {
  const Historia({Key? key}) : super(key: key);

  @override
  State<Historia> createState() => _HistoriaState();
}

class _HistoriaState extends State<Historia> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();



  List<CompletedServices> completedServices= [];

  void createPost(String title, String content) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    String id = localStorage.getString("id").toString();
    print(id);

    final response = await http.post(
      Uri.parse('https://testdiamondapi.onrender.com/posts/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'title': title, 'content': content, 'user': id}),
    );

    print("Title ${titleController.text}");
    print("Content ${contentController.text}");

    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response);
      print('Post created successfully');
    } else {
      // Handle error
      print('Failed to create post ${response.body}');
    }
  }

  void getServicesFromStaff() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();

    String? token = localStorage.getString('token');
    String? id = localStorage.getString('id');
    final response = await http.get(
      Uri.parse("https://testdiamondapi.onrender.com/completedservices/byStaff/$id"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      }
    );

    if (response.statusCode == 200) {
      var resBody = jsonDecode(response.body);
      print(response.statusCode);
      print(id);
      log(response.body);
          if(resBody != null){
            var services = resBody.map<CompletedServices>((json)=>CompletedServices.fromJson(json)).toList();
            setState(() {
              completedServices = services;
            });
          }

    } else {
      log(response.statusCode.toString());

    }
  }

  @override
  void initState() {
    super.initState();
    getServicesFromStaff();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
        //   child: TextFormField(
        //     controller: titleController,
        //     decoration: const InputDecoration(
        //         hintText: 'Title',
        //         border: OutlineInputBorder(),
        //         enabledBorder: OutlineInputBorder()),
        //   ),
        // ),
        // Padding(
        //     padding: EdgeInsets.symmetric(
        //         horizontal: size.width * 0.1, vertical: size.height * 0.03),
        //     child: TextFormField(
        //       controller: contentController,
        //       decoration: const InputDecoration(
        //           hintText: 'Content',
        //           border: OutlineInputBorder(),
        //           enabledBorder: OutlineInputBorder()),
        //     )),
        // GestureDetector(
        //   onTap: () {
        //     createPost(
        //         titleController.text.trim(), contentController.text.trim());
        //     titleController.clear();
        //     contentController.clear();
        //   },
        //   child: Container(
        //     height: size.height * 0.07,
        //     width: size.width * 0.8,
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(10), color: Colors.black87),
        //     child: const Center(
        //         child: Text(
        //       "Post",
        //       style: TextStyle(color: Colors.white, fontSize: 20),
        //     )),
        //   ),
        // ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: completedServices.length,
          itemBuilder: (BuildContext context, int index){
            print(completedServices.length);
            return Container(
              height: size.height*0.12,
              width: size.width,
              margin: EdgeInsets.symmetric(horizontal:size.width*0.05,vertical: size.height*0.01),
              padding: EdgeInsets.symmetric(horizontal: size.width*0.025),
              decoration: BoxDecoration(
                border: Border.all(width: 1,color: Colors.grey[400]!),
                borderRadius: BorderRadius.circular(15)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.account_circle_outlined,size: 35,color: primaryBlue,),
                  const SizedBox(width: 10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(completedServices[index].staff.userName,style:const TextStyle(fontSize: 18),),
                      Text(completedServices[index].client.userName)
                    ],
                  )
                ],
              ),
            );
          },
        )
      ],
    );
  }
}

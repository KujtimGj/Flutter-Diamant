import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcash/features/model/userModel.dart';

class Employees extends StatefulWidget {
  const Employees({Key? key}) : super(key: key);

  @override
  State<Employees> createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  @override



  List<User> userStaff=[];

  getPosts() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try{
      var headers={"Content-Type":"application/json","Authorization":'Bearer $token'};
      var uri = Uri.parse("https://testdiamondapi.onrender.com/users/");

      var response = await http.get(uri,headers: headers);
      var resBody = jsonDecode(response.body);
      if(resBody != null){
        var user = resBody.map<User>((json)=>User.fromJson(json)).toList();
        setState(() {
          userStaff = user;
        });
      }
      if(response.statusCode==200){
        print(resBody);
      }else{
        print(response.statusCode);
      }
    }catch(e){
      print("Error: $e");
    }
  }

  void initState() {
    getPosts();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      margin: EdgeInsets.only(top: size.height*0.05),
      child:ListView.builder(
        shrinkWrap: true,
        itemCount: userStaff.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index){
          return Container(
            height: 80,
            width: size.width,
            margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [
                  Color(0xff90cdd3),
                  Color(0xff90cdd3),
                  Color(0xff96d1cc),
                  Color(0xff96d1cc)
                ]
              )
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(userStaff[index].userName,style:const TextStyle(fontSize: 18),),
                      Text(userStaff[index].email,style: TextStyle(color: Colors.grey[100],fontSize: 14),)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Piket: ${userStaff[index].credit}".toString(),style: TextStyle(color: Colors.grey[100],fontSize: 18),)
                    ],
                  )
                ],
              ),
            ),
          );
        },
      )
    );
  }
}

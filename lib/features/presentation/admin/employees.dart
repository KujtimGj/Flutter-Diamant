import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:warcash/core/consts/dimensions.dart';
import 'package:warcash/features/model/userModel.dart';
import 'package:warcash/features/providers/getProvider.dart';

class Employees extends StatefulWidget {
  const Employees({Key? key}) : super(key: key);

  @override
  State<Employees> createState() => _EmployeesState();
}

class _EmployeesState extends State<Employees> {
  @override

  bool isFetching =false;



  getStaff()async{
    setState(() =>isFetching=true);
    var provider = Provider.of<GetProvider>(context,listen:false);
    List<User>? clients = await provider.getAllStaffs(context);
    if(clients ==null){
      setState(()=>isFetching=false);
    }else{
      print("Failed to fetch posts");
      setState(()=>isFetching=false);
    }
  }
  @override
  void initState() {
    getStaff();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final staffProvider = Provider.of<GetProvider>(context);
    return Container(
      width: size.width,
      margin: EdgeInsets.only(top: size.height*0.05),
      child:ListView.builder(
        shrinkWrap: true,
        itemCount: staffProvider.getStaffs().length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index){
          return Container(
            height: 80,
            width: getPhoneWidth(context),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(staffProvider.getStaffs()[index].userName,style:const TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.w500),),
                      Text(staffProvider.getStaffs()[index].email,style: TextStyle(color: Colors.grey[200],fontSize: 14),)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Piket: ${staffProvider.getStaffs()[index].slotNr}".toString(),style: TextStyle(color: Colors.grey[100],fontSize: 18),)
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

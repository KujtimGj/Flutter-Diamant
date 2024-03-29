import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcash/features/presentation/auth/login.dart';
import 'package:warcash/features/presentation/admin/clients.dart';
import 'package:warcash/features/presentation/admin/employees.dart';
import 'package:warcash/features/presentation/admin/servicesByStaff.dart';
import 'package:warcash/features/presentation/auth/splashscreen.dart';
import 'package:warcash/features/presentation/client/client.dart';

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {

  int selectedIndex=0;
  logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setBool("isLoggedIn", false);
    localStorage.remove("userName");
    localStorage.remove("credit");
    localStorage.remove("role");
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => SplashScreen()), (route) => false);
  }


  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xfff3f7f9),
      body: ListView(
        children: [
          Container(
            height: 80,
            width: size.width,
            decoration:const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(14),bottomRight: Radius.circular(14))
            ),
            child: const Center(
              child: Text("Admin Panel",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500),),
            ),
          ),
          SizedBox(height: size.height*0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: (){
                  setState(() {
                    selectedIndex=0;
                  });
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                    color:selectedIndex==0?const Color(0xff95cfd2):Colors.white,
                    borderRadius: BorderRadius.circular(15),

                  ),
                  child:  Center(
                    child: Text("Puntor",style: TextStyle(fontSize: 16,color:selectedIndex==0?Colors.white:Colors.black),),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    selectedIndex=1;
                  });
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      color: selectedIndex==1?const Color(0xffff5f67):Colors.white,
                      borderRadius: BorderRadius.circular(15),

                  ),
                  child:  Center(
                    child: Text("Klientat",style: TextStyle(fontSize: 16,color:selectedIndex==1?Colors.white:Colors.black),),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    selectedIndex=2;
                  });
                },
                child: Container(
                  height: 40,
                  width: 100,
                  decoration: BoxDecoration(
                      color: selectedIndex==2?const Color(0xff999bf0):Colors.white,
                      borderRadius: BorderRadius.circular(15),
                  ),
                  child:  Center(
                    child: Text("Historia",style: TextStyle(fontSize: 16,color: selectedIndex==2?Colors.white:Colors.black),),
                  ),
                ),
              )
            ],
          ),
          if(selectedIndex==0)...[
            const Employees()
          ]else if(selectedIndex==1)...[
            const Clients()
          ]else...[
            const ServicesByStaff()
          ],
          SizedBox(height: size.height*0.05),

        ],
      ),
    );
  }
}

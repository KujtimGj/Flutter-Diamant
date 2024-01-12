import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warcash/core/consts/dimensions.dart';
import 'package:warcash/features/model/userModel.dart';
import 'package:warcash/features/providers/getProvider.dart';

class Clients extends StatefulWidget {
  const Clients({Key? key}) : super(key: key);

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {

  bool isFetching = false;

  getClients()async{
    setState(() =>isFetching=true);
    var provider = Provider.of<GetProvider>(context,listen:false);
    List<User>? clients = await provider.getAllClients(context);
    if(clients !=null){
      setState(()=>isFetching=false);
    }else{
      print("Failed to fetch posts");
      setState(()=>isFetching=false);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      getClients();
    });
  }

  @override
  Widget build(BuildContext context) {
    final clntProvider = Provider.of<GetProvider>(context);
    return Container(
      width: getPhoneWidth(context),
      margin: EdgeInsets.only(top: getPhoneHeight(context)*0.05),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: clntProvider.getClients().length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index){
          print(clntProvider.getClients().length);
          return Container(
            height: 80,
            width: getPhoneWidth(context),
            margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                    colors: [
                      Color(0xffff5f67),
                      Color(0xffff5f67),
                      Color(0xfff8646c),
                      Color(0xfff8646c)
                    ]
                )
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(clntProvider.getClients()[index].userName,style: const TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.white),),
                      Text(clntProvider.getClients()[index].subscription,style: TextStyle(fontSize: 17,fontWeight: FontWeight.w500,color: Colors.grey[300]),)
                    ],
                  ),
                  Text('${clntProvider.getClients()[index].credit} credits',style:const TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w500),)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

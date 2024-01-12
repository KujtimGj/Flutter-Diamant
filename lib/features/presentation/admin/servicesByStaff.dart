import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcash/core/consts/dimensions.dart';
import 'package:warcash/features/model/completedServicesModel.dart';
import 'package:warcash/features/model/userModel.dart';
import 'package:warcash/features/presentation/auth/splashscreen.dart';
import 'package:warcash/features/providers/getProvider.dart';

class ServicesByStaff extends StatefulWidget {
  const ServicesByStaff({Key? key}) : super(key: key);

  @override
  State<ServicesByStaff> createState() => _ServicesByStaffState();
}

class _ServicesByStaffState extends State<ServicesByStaff> {

    logout() async {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setBool("isLoggedIn", false);
      localStorage.remove("firstName");
      localStorage.remove('lastName');
      localStorage.remove('token');
      localStorage.remove("role");
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (_) => SplashScreen()), (route) => false);
    }

    bool isFetching=false;
    getCS()async{
      setState(()=>isFetching=true);
      var provider = Provider.of<GetProvider>(context,listen:false);
      List<CompletedServices> completedServices = await provider.getCompletedServices(context);
      if(completedServices !=null){
        setState(() =>isFetching=false);
      }else{
        print("Failed to fetch completed services");
        setState(()=>isFetching=false);
      }
    }

    bool fetchStaff =false;

    getStaff()async{
      setState(() =>fetchStaff=true);
      var provider = Provider.of<GetProvider>(context,listen:false);
      List<User>? clients = await provider.getAllStaffs(context);
      if(clients ==null){
        setState(()=>fetchStaff=false);
      }else{
        print("Failed to fetch posts");
        setState(()=>fetchStaff=false);
      }
    }
    List<User>? clients =[];



    @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCS();
      getStaff();
    });
    print("initialized");
    super.initState();
  }
    final List<String> items = [
      'Item1',
      'Item2',
      'Item3',
      'Item4',
    ];
    String? selectedValue;
  @override
  Widget build(BuildContext context) {
      final provider = Provider.of<GetProvider>(context);
    return SizedBox(
      width: getPhoneWidth(context),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            padding:  const EdgeInsets.all(8),
            width: getPhoneWidth(context)*0.95,
            child: DropdownButtonHideUnderline(
              child: DropdownButton2<String>(
                isExpanded: true,
                hint: Text(
                  'Zgjedh puntorin',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).hintColor,
                    fontWeight: FontWeight.w600
                  ),
                ),
                items: items
                    .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
                    .toList(),
                value: selectedValue,
                onChanged: (String? value) {
                  setState(() {
                    selectedValue = value;
                  });
                },
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
          const SizedBox(height: 20),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: provider.getAllCompletedServices().length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index){
                return Container(
                height: getPhoneHeight(context)*0.15,
                width: getPhoneWidth(context)*0.85,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(2,5),
                        blurRadius: 5,
                        color: Colors.grey[400]!,
                      )
                    ]
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex:1,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Nga: ${provider.getAllCompletedServices()[index].staff.userName}'),
                                Text("Per:${provider.getAllCompletedServices()[index].client.userName}")
                              ],
                            ),
                          )
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(provider.getAllCompletedServices()[index].service.name),
                              Text(provider.getAllCompletedServices()[index].service.cost.toString())
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
              );
              },
          ),
          GestureDetector(
              onTap: (){
                logout();
              },
              child: const Text("Sign out",style: TextStyle(color: Colors.red,fontSize: 20,fontWeight: FontWeight.w500),))
        ],
      ),
    );
  }
}

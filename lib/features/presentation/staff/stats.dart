import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcash/features/model/slotModel.dart';
import 'package:warcash/features/presentation/staff/curvepaint.dart';
import 'package:warcash/features/providers/SlotProvider.dart';
import 'package:provider/provider.dart';
import 'package:warcash/features/providers/StaffAuthProvider.dart';

class Stats extends StatefulWidget {
  Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  bool isOpen = true;

  bool fetchingSlots = false;

  getSlots() async {
    setState(() => fetchingSlots = true);
    var provider = Provider.of<SlotProvider>(context, listen: false);
    var result = await provider.getAllSlots(context);

    if (result == null) {
      setState(() => fetchingSlots = false);
    } else {
      print('Failed to fetch slots');
      setState(() => fetchingSlots = false);
    }
  }

  int? credit;
  int? carswashed;
  getUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      credit = int.parse(localStorage.getInt('credit').toString());
      carswashed = int.parse(localStorage.getInt('carswashed').toString());
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getSlots();
      getUserData();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StaffAuthProvider>(context);
    Size size = MediaQuery.of(context).size;
    final slotProvider = Provider.of<SlotProvider>(context);
    return Column(
      children: [
        SizedBox(
          height: 50,
          width: size.width,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
            child: const CustomPaint(
              child: CurvePainterWidget(),
            ),
          ),
        ),
        SizedBox(height: size.height * 0.03),
        Text(
          credit.toString(),
          style:const TextStyle(
              color: Colors.black, fontSize: 26, fontWeight: FontWeight.w800),
        ),
        const Text(
          "pikë të mbledhura",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        SizedBox(height: size.height * 0.1),
        Text(
          carswashed.toString(),
          style:const TextStyle(
              color: Colors.black, fontSize: 26, fontWeight: FontWeight.w800),
        ),
        const Text(
          "vetura te lara",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        SizedBox(height: size.height * 0.1),
        SizedBox(
          width: size.width,
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: slotProvider.getSlots()!.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: size.height,
                width: 60,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.blue),
                ),
                child: Center(
                  child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(fontSize: 20, color: Colors.blue),
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

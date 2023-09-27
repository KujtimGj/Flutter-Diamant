import 'package:flutter/material.dart';
import 'package:warcash/home/staff/curvepaint.dart';

class Stats extends StatelessWidget {
  const Stats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(
          height: 50,
          width: size.width,
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: size.width*0.04),
            child: const CustomPaint(
              child: CurvePainterWidget(),
            ),
          ),
        ),
        SizedBox(height: size.height * 0.03),
        const Text("120",style: TextStyle(color: Colors.black,fontSize: 26,fontWeight: FontWeight.w800),),
        const Text("pikë të mbledhura",style: TextStyle(color: Colors.black,fontSize: 16),),
        SizedBox(height: size.height*0.1),
        const Text("24",style: TextStyle(color: Colors.black,fontSize: 26,fontWeight: FontWeight.w800),),
        const Text("vetura te lara",style: TextStyle(color: Colors.black,fontSize: 16),),
        SizedBox(height: size.height*0.1),
        const Text("91",style: TextStyle(color: Colors.black,fontSize: 26,fontWeight: FontWeight.w800),),
        const Text("example statistic",style: TextStyle(color: Colors.black,fontSize: 16),),
      ],
    );

  }
}

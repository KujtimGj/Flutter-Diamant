import 'package:flutter/material.dart';
import 'package:warcash/home/staff/curvepaint.dart';

class Stats extends StatefulWidget {
  Stats({Key? key}) : super(key: key);

  @override
  State<Stats> createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  bool isOpen = true;

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
        Container(
          width: size.width,
          height: 100,

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: size.height,
                width: 60,
                decoration: BoxDecoration(
                  border:Border.all(width: 1,color: Colors.blue),
                ),
                child: const Center(
                  child: Text("1",style: TextStyle(fontSize: 20,color: Colors.blue),),
                ),
              ),
              Container(
                height: size.height,
                width: 60,
                decoration: BoxDecoration(
                  border:Border.all(width: 1,color: Colors.blue),
                ),
                child: const Center(
                  child: Text("2",style: TextStyle(fontSize: 20,color: Colors.blue),),
                ),
              ),
              Container(
                height: size.height,
                width: 60,
                decoration: BoxDecoration(
                  border:Border.all(width: 1,color: Colors.blue),
                ),
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      isOpen= !isOpen;
                    });
                    print("triggered");
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    decoration:  BoxDecoration(
                      shape: BoxShape.circle,
                      color: isOpen==true?Colors.green:Colors.red
                    ),
                  ),
                )
              ),
              Container(
                height: size.height,
                width: 60,
                decoration: BoxDecoration(
                  border:Border.all(width: 1,color: Colors.blue),
                ),
                child: const Center(
                  child: Text("4",style: TextStyle(fontSize: 20,color: Colors.blue),),
                ),
              ),
            ],
          ),
        )
      ],
    );

  }
}

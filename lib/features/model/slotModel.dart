import 'package:mongo_dart/mongo_dart.dart';

class SlotModel{
  String? owner;
  ObjectId? id;
  int? slotNr;
  bool? isAvailable;

  SlotModel({required this.owner,required this.slotNr, required this.id, required this.isAvailable});

  factory SlotModel.fromJson(Map<String, dynamic>json){
    return SlotModel(
        owner: json['owner'],
        slotNr: json['slotNr'],
        id: json['id'],
        isAvailable: json['isAvailable']
    );
  }

  Map<String, dynamic> toJson()=>{

      "_id":id,
      "owner":owner,
      "slotNr":slotNr,
      "isAvailable":isAvailable

  };
}
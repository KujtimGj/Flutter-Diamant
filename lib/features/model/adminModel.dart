import 'package:mongo_dart/mongo_dart.dart' as M;
class AdminModel{
  M.ObjectId id;
  String firstName,lastName,email,password;
  int? role;

  AdminModel({required this.id, required this.firstName, required this.lastName, required this.email,required this.password, required this.role});

  factory AdminModel.fromJson(Map<String,dynamic>fromJson)=> AdminModel(
      id:  M.ObjectId.fromHexString(fromJson['_id']),
      firstName: fromJson['firstName'],
      lastName: fromJson['lastName'],
      email: fromJson['email'],
      password: fromJson['password'],
      role: fromJson['role'] as int? ?? 0
  );


  Map<String, dynamic> toJson(){
    return{
      '_id':id,
      'firstName':firstName,
      'lastName':lastName,
      'email':email,
      'password':password,
      'role':role

    };
  }


}
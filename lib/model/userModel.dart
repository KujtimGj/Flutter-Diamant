import 'package:mongo_dart/mongo_dart.dart' as M;

class User{
  String userName, email, password,qrCode,subscription;
  int phone,credit, role;
  M.ObjectId id;

  User({required this.userName,required this.email, required this.password, required this.qrCode,required this.subscription,required this.phone, required this.role, required this.credit, required this.id });

  factory User.fromJson(Map<String, dynamic>fromJson){
  return User(
      userName: fromJson['userName'],
      email: fromJson['email'],
      password: fromJson['password'],
      qrCode: fromJson['qrCode'],
      subscription: fromJson['subscription'],
      phone: fromJson['phone'],
      role: fromJson['role'],
      credit: fromJson['credit'],
      id: fromJson['_id']);
  }

}
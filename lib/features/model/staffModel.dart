class StaffModel {
  String id;
  String userName;
  String email;
  String password;
  int role;
  int phone;
  int staffCredit;
  int slotNr;

  StaffModel({
    required this.id,
    required this.userName,
    required this.email,
    required this.password,
    required this.role,
    required this.phone,
    required this.staffCredit,
    required this.slotNr,
  });

  factory StaffModel.fromJson(Map<String, dynamic> json) {
    return StaffModel(
    id: json["_id"],
    userName: json["userName"],
    email: json["email"],
    password: json["password"],
    role: json["role"] as int? ?? 0,
    phone: json["phone"] as int? ?? 0,
    staffCredit: json["staffCredit"]as int? ?? 0,
    slotNr: json["slotNr"] as int? ?? 0,
  );}

  Map<String, dynamic> toJson() =>{
      "_id": id,
    "userName": userName,
    "email": email,
    "password": password,
    "role": role,
    "phone": phone,
    "staffCredit": staffCredit,
    "slotNr":slotNr,
  };
}
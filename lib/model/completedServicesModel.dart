class CompletedServices {
  String id;
  String serviceID;
  int creditUsed;
  DateTime createdAt;
  DateTime updatedAt;
  Staff staff;
  Client client;

  CompletedServices({
    required this.id,
    required this.serviceID,
    required this.creditUsed,
    required this.createdAt,
    required this.updatedAt,
    required this.staff,
    required this.client,
  });

  factory CompletedServices.fromJson(Map<String, dynamic> fromJson) {
    return CompletedServices(
      id: fromJson['_id'],
      serviceID: fromJson['ServiceID'],
      creditUsed: fromJson['CreditUsed'],
      createdAt: DateTime.parse(fromJson['createdAt']),
      updatedAt: DateTime.parse(fromJson['updatedAt']),
      staff: Staff.fromJson(fromJson['staff']),
      client: Client.fromJson(fromJson['client']),
    );
  }
}

class Staff {
  String id;
  String userName;
  String email;

  Staff({
    required this.id,
    required this.userName,
    required this.email,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['_id'],
      userName: json['userName'],
      email: json['email'],
    );
  }
}

class Client {
  String id;
  String userName;
  String email;

  Client({
    required this.id,
    required this.userName,
    required this.email,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['_id'],
      userName: json['userName'],
      email: json['email'],
    );
  }
}

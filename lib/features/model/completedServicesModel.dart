class CompletedServices {
  String id;
  String serviceId;
  int creditUsed;
  DateTime createdAt;
  DateTime updatedAt;
  Client staff;
  Client client;
  Service service;

  CompletedServices({
    required this.id,
    required this.serviceId,
    required this.creditUsed,
    required this.createdAt,
    required this.updatedAt,
    required this.staff,
    required this.client,
    required this.service,
  });



  factory CompletedServices.fromJson(Map<String, dynamic> json) => CompletedServices(
    id: json["_id"],
    serviceId: json["ServiceID"],
    creditUsed: json["CreditUsed"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    staff: Client.fromJson(json["staff"]),
    client: Client.fromJson(json["client"]),
    service: Service.fromJson(json["service"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "ServiceID": serviceId,
    "CreditUsed": creditUsed,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "staff": staff.toJson(),
    "client": client.toJson(),
    "service": service.toJson(),
  };
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



  factory Client.fromJson(Map<String, dynamic> json) => Client(
    id: json["_id"],
    userName: json["userName"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "userName": userName,
    "email": email,
  };
}

class Service {
  String id;
  String name;
  int cost;

  Service({
    required this.id,
    required this.name,
    required this.cost,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["_id"],
    name: json["name"],
    cost: json["cost"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "cost": cost,
  };
}

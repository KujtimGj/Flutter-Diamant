class CompletedServices{
  String ClientID, StaffID, ServiceID,CreditUsed;

  CompletedServices({required this.ClientID,required this.StaffID, required this.ServiceID, required this.CreditUsed});

  factory CompletedServices.fromJson(Map<String, dynamic> fromJson){
    return CompletedServices(
        ClientID: fromJson['ClientID'],
        StaffID: fromJson['StaffID'],
        ServiceID: fromJson['ServiceID'],
        CreditUsed: fromJson['ServiceID']
    );
  }
}
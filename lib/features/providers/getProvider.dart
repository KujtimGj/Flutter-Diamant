import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warcash/features/controllers/gets.dart';
import 'package:warcash/features/model/completedServicesModel.dart';
import 'package:warcash/features/model/staffModel.dart';
import 'package:warcash/features/model/userModel.dart';

class GetProvider extends ChangeNotifier{
  GetController? getController;
  List<User> _clients=[];
  List<StaffModel> _staffs=[];
  List<CompletedServices> _completedServices=[];
  List<CompletedServices> _completedServicesByStaff=[];

  List<CompletedServices> getAllCompletedServices()=>_completedServices;
  List<CompletedServices> getAllCompletedServicesByStaff()=>_completedServicesByStaff;
  List<StaffModel> getStaffs()=>_staffs;
  List<User> getClients()=> _clients;

  getAllClients(context)async{
    getController=GetController();
    var result = await getController!.getClients();
    return result.fold((failure){
      print(failure);
    }, (clients)async{
      _clients=clients;
      notifyListeners();
    });
  }

  getAllStaffs(context)async{
    getController=GetController();
    var result = await getController!.getStaff();
    return result.fold((failure){
      print(failure);
      print("asdasd");
    }, (staffs){
      _staffs=staffs;
      notifyListeners();
    }
    );
  }
  getCompletedServices(context)async{
    getController = GetController();
    var result = await getController!.getCompletedServices();
    return result.fold((failure){
      print("Failure");
    },(completedServices){
      _completedServices = completedServices;
      notifyListeners();
    });
  }

  getCompletedServicesByStaff(context)async{
    getController = GetController();
    var result = await getController!.getCompletedServicesByClient();
    return result.fold((failure){
      print(failure);
    },(completedServicesByStaff){
      _completedServicesByStaff = completedServicesByStaff;
      notifyListeners();
    });
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warcash/features/controllers/gets.dart';
import 'package:warcash/features/model/staffModel.dart';
import 'package:warcash/features/model/userModel.dart';

class GetProvider extends ChangeNotifier{
  GetController? getController;
  List<User> _clients=[];

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

}
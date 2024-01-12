import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcash/core/errors/failures.dart';
import 'package:warcash/core/strings/api_url.dart';
import 'package:warcash/features/model/completedServicesModel.dart';
import 'package:warcash/features/model/staffModel.dart';
import 'package:http/http.dart' as http;
import 'package:warcash/features/model/userModel.dart';
import 'package:warcash/features/model/userModel.dart';
import 'package:warcash/features/model/userModel.dart';

class GetController{

  // Klientat
  Future<Either<Failure,List<User>>> getClients() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var headers = {"Content-Type":"application/json","Authorization":"Bearer $token"};
    try{
      var url = Uri.parse(getClnt);
      var res = await http.get(url,headers: headers);
      var decodedData = jsonDecode(res.body);
      if (res.statusCode == 200) {
        if (decodedData.containsKey('client') && decodedData['client'] is List) {
          List<User> clients = (decodedData['client'] as List)
              .map<User>((json) => User.fromJson(json))
              .toList();
          print(clients);
          return Right(clients);
        } else {
          return Left(ServerFailure(message: "Invalid response format"));
        }}else if(res.statusCode==401){
        return Left(ServerFailure());
      }
    }catch(e){
      print("Error during fetch: $e");
      return Left(ServerFailure());
    }
    return Left(ServerFailure());
  }
  // Staffi
  Future<Either<Failure,List<StaffModel>>> getStaff()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    var headers = {"Content-Type":"application/json","Authorization":"Bearer $token"};
    try{
      var url = Uri.parse(getStaf);
      var res = await http.get(url,headers: headers);
      var resBody = jsonDecode(res.body);
      if(res.statusCode==200){
        List<StaffModel> staffs = (resBody as List).map<StaffModel>((json) => StaffModel.fromJson(json)).toList();
        return Right(staffs);
      }
    }catch(e){
      print("Error during staff fetch:$e");
      return Left(ServerFailure());
    }
    return Left(ServerFailure());
  }
  // GET ALL SERVICES
  Future<Either<Failure,List<CompletedServices>>> getCompletedServicesByClient() async{
    try{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      String? uid=prefs.getString("id");
      var headers = {"Content-Type":"application/json","Authorization":"Bearer $token"};
      var url = Uri.parse("$getCservicesByClient/$uid");
      print(url);
      var res = await http.get(url,headers: headers);
      if(res.statusCode==200){
        var resBody = jsonDecode(res.body);
        if(resBody is List){
          List<CompletedServices> completedServices = resBody.map<CompletedServices>((json)=>CompletedServices.fromJson(json)).toList();
          return Right(completedServices);
        }else{
          return Left(ServerFailure(message: "Invalid response format"));
        }
      }else{
        return Left(ServerFailure(message: "Failed to fetch completed services. Status code: ${res.statusCode}"));
      }
    }catch(e){
      print("Error:$e");
      return Left(ServerFailure());
    }
  }
  Future<Either<Failure, List<CompletedServices>>> getCompletedServices() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var headers = {"Content-Type": "application/json", "Authorization": "Bearer $token"};
      var url = Uri.parse(getCservices);
      var res = await http.get(url, headers: headers);
      if (res.statusCode == 200) {
        var resBody = jsonDecode(res.body);

        if (resBody is List) {
          List<CompletedServices> completedServices = resBody
              .map<CompletedServices>((json) => CompletedServices.fromJson(json))
              .toList();

          return Right(completedServices);
        } else {
          return Left(ServerFailure(message: "Invalid response format"));
        }
      } else {
        return Left(ServerFailure(message: "Failed to fetch completed services. Status code: ${res.statusCode}"));
      }
    } catch (e) {
      print("Error: $e");
      return Left(ServerFailure());
    }
  }

}
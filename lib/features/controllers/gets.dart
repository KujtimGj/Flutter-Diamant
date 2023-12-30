import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:warcash/core/errors/failures.dart';
import 'package:warcash/core/strings/api_url.dart';
import 'package:warcash/features/model/staffModel.dart';
import 'package:http/http.dart' as http;
import 'package:warcash/features/model/userModel.dart';
import 'package:warcash/features/model/userModel.dart';
import 'package:warcash/features/model/userModel.dart';

class GetController{
  var headers = {"Content-Type":"application/json"};
  
  Future<Either<Failure,List<User>>> getClients() async{
    try{
      var url = Uri.parse(getStaf);
      var res = await http.get(url,headers: headers);
      var decodedData = jsonDecode(res.body);
      if(res.statusCode == 200){
        List<User> clients = (decodedData as List).map<User>((json)=>User.fromJson(json)).toList();
        return Right(clients);
      }else if(res.statusCode==401){
        return Left(ServerFailure());
      }
    }catch(e){
      print("Error during fetch: $e");
      return Left(ServerFailure());
    }
    return Left(ServerFailure());
  }
}
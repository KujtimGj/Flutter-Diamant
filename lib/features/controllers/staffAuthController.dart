import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcash/core/errors/failures.dart';
import 'package:warcash/core/strings/api_url.dart';
import 'package:warcash/features/model/adminModel.dart';
import 'package:warcash/features/model/staffModel.dart';
import 'package:warcash/features/model/userModel.dart';
import 'package:warcash/features/presentation/admin/admin.dart';

class StaffAuthController {
  var headers = {'Content-Type': 'application/json'};


  Future<Either<Failure, StaffModel>> loginStaff(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var url = Uri.parse('$host$staffLogin');
      print(url);
      var data = {"email": email, "password": password};
      var response =
          await http.post(url, headers: headers, body: jsonEncode(data));
      var resBody = jsonDecode(response.body);
      print(resBody);
      if (response.statusCode == 200) {
        if (resBody['token'].isNotEmpty && resBody['token'] != null) {
          print(resBody['token']);
          prefs.setString("token", resBody['token']);
          prefs.setString("id", resBody['staff']['_id']);
          prefs.setBool("isLoggedIn", true);
          prefs.setString("userName", resBody['staff']['userName']);
          prefs.setInt("credit", resBody['staff']['staffCredit']);
          prefs.setInt("role", resBody['staff']['role']);

          var staffModel = StaffModel.fromJson(resBody['staff']);
          return Right(staffModel);
        }
      } else if (response.statusCode == 401) {
        return Left(UnauthorizedFailure());
      } else {
        print(
            "Login failed - Status code: ${response.statusCode}, body:${response.body}");
        return Left(ServerFailure());
      }
    } catch (e) {
      print("Error during login: $e");
      return Left(ServerFailure());
    }
    return Left(ServerFailure());
  }

  Future<Either<Failure, StaffModel>> registerStaff(StaffModel staffModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var url = Uri.parse('$host$staffSignup');
      var body = jsonEncode(staffModel.toJson());

      var response = await http.post(url, headers: headers, body: body);
      var resBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        StaffModel staff = StaffModel.fromJson(resBody);
        return Right(staff);
      } else {
        print("HTTP Error: ${response.statusCode}");
        print("Response Body: ${response.body}");
        return Left(ServerFailure(message: 'Invalid response data'));
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  Future<Either<Failure,AdminModel>> loginAdmin(email,password)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try{
      var url = Uri.parse('$adminLogin');
      var data = {"email": email, "password": password};
      var response = await http.post(url, headers: headers, body: jsonEncode(data));
      var resBody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (resBody['token'].isNotEmpty && resBody['token'] != null) {
          print(resBody['token']);
          prefs.setString("token", resBody['token']);
          prefs.setString("id", resBody['admin']['_id']);
          prefs.setBool("isLoggedIn", true);
          prefs.setString("firstName", resBody['admin']['firstName']);
          prefs.setString("lastName", resBody['admin']['lastName']);
          prefs.setInt("role", resBody['admin']['role']);

          var adminModel = AdminModel.fromJson(resBody['admin']);
          return Right(adminModel);
        }
      }else if (response.statusCode == 401) {
        return Left(UnauthorizedFailure());
      } else {
        print("Login failed - Status code: ${response.statusCode}, body:${response.body}");
        return Left(ServerFailure());
      }
    }catch(e){
      print("Error during login: $e");
      return Left(ServerFailure());
    }
    return Left(ServerFailure());
  }

}

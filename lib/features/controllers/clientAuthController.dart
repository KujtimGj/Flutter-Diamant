import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcash/core/errors/failures.dart';
import 'package:warcash/core/strings/api_url.dart';
import 'package:warcash/features/model/userModel.dart';

class ClientAuthController {
  var headers = {'Content-Type': 'application/json'};

  Future<Either<Failure, User>> loginClient(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      var url = Uri.parse('$host$clientLogin');
      print(url);
      var data = {"email": email, "password": password};
      var response = await http.post(url, headers: headers, body: jsonEncode(data));

      if (response.statusCode == 200) {
        var resBody = jsonDecode(response.body);
        if (resBody != null && resBody['token'].isNotEmpty && resBody['token'] != null) {
          print(resBody['token']);
          prefs.setString("token", resBody['token']);
          prefs.setString("id", resBody['user']['_id']);
          prefs.setBool("isLoggedIn", true);
          prefs.setString("userName", resBody['user']['userName']);
          prefs.setString('qrCode',resBody['user']['qrCode']);
          prefs.setInt("credit", resBody['user']['credit']);
          prefs.setInt("role", resBody['user']['role']);
          print(resBody['user']['qrCode']);
          var clientModel = User.fromJson(resBody['user']);
          return Right(clientModel);
        } else {
          return Left(ServerFailure());
        }
      } else if (response.statusCode == 401) {
        return Left(UnauthorizedFailure());
      } else {
        return Left(ServerFailure());
      }
    } catch (e) {
      print("Error during login: $e");
      return Left(ServerFailure());
    }
  }

}

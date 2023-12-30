import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warcash/core/errors/failures.dart';
import 'package:warcash/core/strings/api_url.dart';
import 'package:warcash/features/model/slotModel.dart';
import 'package:http/http.dart' as http;

class SlotController {
  Future<Either<Failure, List<SlotModel>>> getSlots() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    try {
      var headers = {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'};
      var url = Uri.parse("$getAllSlots");
      print(url);
      var response = await http.get(url, headers: headers);
      var resBody = jsonDecode(response.body);
      var slotNr = resBody['owmer'];
      if(slotNr == token){

      }
      print(resBody);
      if (response.statusCode == 200) {
        List<SlotModel> slots = (resBody as List).map<SlotModel>((json) => SlotModel.fromJson(json)).toList();
        return Right(slots);
      } else {
        return Left(ServerFailure());
      }
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}

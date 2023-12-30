import 'package:flutter/cupertino.dart';
import 'package:warcash/features/controllers/clientAuthController.dart';
import 'package:warcash/features/model/userModel.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;

class ClientAuthProvider extends ChangeNotifier{
  User? _client;
  ClientAuthController? clientAuthController;

  User? getClient() => _client;

  ClientAuthProvider() {
    clientAuthController = ClientAuthController();
  }

  Future<User?> loginClient(String email, String password) async {
    if (clientAuthController == null) {
      print("Login controller is null. Cannot perform login");

      return null;
    }
    var result = await clientAuthController!.loginClient(email, password);

    return result.fold((failure) {
      print('Login failure: $failure');
    }, (client) {
      _client = User(
          userName: client.userName,
          email: email,
          password: password,
          qrCode: client.qrCode,
          subscription: client.subscription,
          phone: client.phone,
          role: client.role,
          credit: client.credit,
          id: M.ObjectId());
      return _client;
    });
  }
}

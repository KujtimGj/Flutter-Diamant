import 'package:flutter/material.dart';
import 'package:warcash/core/errors/failures.dart';
import 'package:warcash/features/controllers/staffAuth.dart';
import 'package:warcash/features/model/staffModel.dart';
import 'package:mongo_dart/mongo_dart.dart' as M;
import 'package:warcash/features/presentation/auth/login.dart';
import 'package:warcash/features/presentation/auth/loginstaff.dart';
import '../../model/staffModel.dart';

class StaffAuthProvider extends ChangeNotifier {
  StaffModel? _staff;
  StaffAuthController? authController;

  StaffModel? getStaff() => _staff;

  StaffAuthProvider(){
    authController = StaffAuthController();
  }

  Future<StaffModel?> login(String email, String password) async {
    if (authController == null) {
      print("Login controller is null. Cannot perform login");
      return null;
    }
    print(email);

    var result = await authController!.loginStaff(email, password);

    return result.fold((failure) {
      print("Login failed: $failure");
      return null;
    }, (staff) {
      _staff = StaffModel(
          id: M.ObjectId().toString(),
          userName: staff.userName,
          email: email,
          password: password,
          role: staff.role,
          phone: staff.phone,
          staffCredit: staff.staffCredit,
          slotNr: staff.slotNr);
      print(_staff);
      return _staff;
    });
  }

  Future<void> register(BuildContext context, StaffModel staffModel) async {
    authController = StaffAuthController();
    var result = await authController!.registerStaff(staffModel);

    result.fold((failure) => showFailureModal(context, failure), (staff) {
      _staff = staff;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginStaff()),
          (route) => false);
    });
  }
}

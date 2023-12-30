import 'package:equatable/equatable.dart';
import 'package:warcash/features/presentation/auth/loginstaff.dart';
import '../consts/const.dart';
import '../consts/dimensions.dart';
import 'failure_strings.dart';
import 'package:flutter/material.dart';

abstract class Failure extends Equatable {}

class OfflineFailure extends Failure {
  final String? message;
  OfflineFailure({this.message});
  @override
  List<Object?> get props => [message ?? OFFLINE_FAILURE_MESSAGE];
}

class ServerFailure extends Failure {
  final String? message;
  ServerFailure({this.message});
  @override
  List<Object?> get props => [message ?? SERVER_FAILURE_MESSAGE];
}

class DuplicateFailure extends Failure {
  final String? message;
  DuplicateFailure({this.message});
  @override
  List<Object?> get props => [message ?? DUPLICATE_FAILURE_MESSAGE];
}

class UnfilledDataFailure extends Failure {
  final String? message;
  UnfilledDataFailure({this.message});
  @override
  List<Object?> get props => [message ?? EMPTY_BODY_FAILURE_MESSAGE];
}

class NotFoundFailure extends Failure {
  final String? message;
  NotFoundFailure({this.message});
  @override
  List<Object?> get props => [message ?? NOT_FOUND_FAILURE_MESSAGE];
}

class WrongDataFailure extends Failure {
  final String? message;
  WrongDataFailure({this.message});
  @override
  List<Object?> get props => [message ?? WRONG_DATA_FAILURE_MESSAGE];
}

class UnauthorizedFailure extends Failure {
  final String? message;
  UnauthorizedFailure({this.message});
  @override
  List<Object?> get props => [message ?? NOT_AUTHORIZED_FAILURE_MESSAGE];
}

class NothingFailure extends Failure {
  @override
  List<Object?> get props => [];
}


void showErrorMessage(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void handleErrorResponse(BuildContext context, Map<String, dynamic> resBody) {
  if (resBody['error'] == 'Incorrect email') {
    showErrorMessage(context, 'Incorrect email');
  } else if (resBody['error'] == 'Incorrect password') {
    showErrorMessage(context, 'Incorrect password');
  } else if (resBody['error'] == 'All fields must be filled!') {
    showErrorMessage(context, 'Please fill all fields!');
  } else if (resBody['error'] == 'Please type in your email!') {
    showErrorMessage(context, 'Please type in your email!');
  } else if (resBody['error'] == 'Please type in your password!') {
    showErrorMessage(context, 'Please type in your password!');
  } else {
    showErrorMessage(context, 'Unexpected error occurred');
  }

  print(resBody.toString());
}


showFailureModal(BuildContext context,Failure f){

  var failure = f.runtimeType;
  if(failure == ServerFailure){
    getFailureModal(context, f.props.first.toString());
  }
  else if(failure == OfflineFailure){
    getFailureModal(context, f.props.first.toString());

  }
  else if(failure == WrongDataFailure){
    getFailureModal(context, f.props.first.toString());
  }
  else if(failure == UnauthorizedFailure){
    getFailureModal(context, f.props.first.toString(),logout: false);
  }
  else if(failure == UnfilledDataFailure){
    getFailureModal(context, f.props.first.toString());
  }
  else if(failure == DuplicateFailure){
    getFailureModal(context, f.props.first.toString());
  }
  else{
  }




}

getFailureModal(BuildContext context,String messageFailure,{bool? logout,bool? shouldPop}){
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: Container(
            width: getPhoneWidth(context),
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    messageFailure,textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w500,color: Colors.black),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: getPhoneWidth(context) * 0.5,
                        height: 42,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: primaryBlue),
                        child: TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Largo",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }).then((value) {
    if(logout != null && logout){

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginStaff()), (route) => false);
    }
  });
}

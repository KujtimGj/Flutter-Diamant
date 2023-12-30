import 'package:flutter/material.dart';
import 'package:warcash/core/errors/failures.dart';
import 'package:warcash/features/controllers/slotController.dart';
import 'package:warcash/features/model/slotModel.dart';

class SlotProvider extends ChangeNotifier {
  SlotController? slotController;
  List<SlotModel>? _slots = [];

  List<SlotModel>? getSlots() => _slots;

  getAllSlots(context) async {
    slotController = SlotController();
    var result = await slotController!.getSlots();
    return result.fold(
          (failure) {
        print('FAILURE');
        print(failure);
        // Return the failure object to the caller
        return failure;
      },
          (slots) async{
        _slots = slots;
        notifyListeners();
        return null;
      });
  }
}

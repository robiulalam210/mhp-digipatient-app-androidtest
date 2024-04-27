import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/clinic/orgamozationlist_model.dart';
import '../../../repository/my_clinic_repository/my_Clinic_repo.dart';
import '../../../utils/message.dart';
import '../../../utils/user.dart';



class MyClinicDoctorViewModel with ChangeNotifier {
  final myRepo = MyClinicRepo();
  TextEditingController controllerRequest=TextEditingController();

  clinicRequest(BuildContext context, orId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int? id = prefs.getInt(UserP.id);
    Map body = {
      "code": "OC-${orId.toString()}",
      "patient_id": id.toString()
    };
    print(body);
    await myRepo.postclinicRequest(body).then((value) {
      print(value);
      print("postclinicRequest");
      getoriganization(context);
      controllerRequest.clear();

      // if (value['message'].toString() == "Successfully store data") {
      //   Messages.snackBar(context, value['message'].toString(),
      //       backgroundColor: Colors.green);
      //
      // } else {
      //   Messages.snackBar(context, value['message'].toString());
      // }

      notifyListeners();
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      debugPrint(stackTrace.toString());
    });

    notifyListeners();
  }

  List<OrganizationListModle> organizationlistmodel = [];

  bool isorgaizationLoading = true;

  getoriganization(BuildContext context) async {
    organizationlistmodel.clear();

    isorgaizationLoading = true;

    notifyListeners();
    await myRepo.getoriganization(context).then((value) {
      organizationlistmodel = value;

      isorgaizationLoading = false;
      notifyListeners();
    }).onError((error, stackTrace) {
      isorgaizationLoading = true;
      debugPrint(error.toString());
      print(stackTrace);

      Messages.snackBar(
        context,
        error.toString(),
      );
    });

    notifyListeners();
  }
}


import 'package:digi_patient/model/my_medicine_model/current_rx_model.dart';
import 'package:digi_patient/model/my_medicine_model/past_rx_model.dart';
import 'package:digi_patient/repository/my_medicine_repo/my_medicine_repo.dart';
import 'package:flutter/cupertino.dart';

import '../../model/my_medicine_model/my_report_model.dart';
import '../../model/my_medicine_model/prescription_image_list.dart';

class MyMedicineViewModel with ChangeNotifier{

  final medicineRepo = MyMedicineRepo();

  List<CurrentRxModel> currentRxList = [];

  List<PastRxModel> pastRxList = [];
  List<PreccriptionListModel> imageRxList = [];
  List<MyReportImageModel> myreportimageRxList = [];

  // List<Drugs> drugList = [];
  bool isPrescriptionRxLoading = true;
  bool ismyreportLoading = true;

  bool isCurrentRxLoading = true;
  bool isPastRxLoading = true;
  getMyReport(BuildContext context) async {
    ismyreportLoading = true;
    myreportimageRxList.clear();

    notifyListeners();
    medicineRepo.getmyreport().then((value) {

      myreportimageRxList = value;

      ismyreportLoading = false;
      notifyListeners();
    }).onError((error, stackTrace) {
      ismyreportLoading = true;
      notifyListeners();
    });
  } getPrescriptionRx(BuildContext context) async {
    isPrescriptionRxLoading = true;
    imageRxList.clear();

    notifyListeners();
    medicineRepo.getprescriptionImage().then((value) {

      imageRxList = value;

      isPrescriptionRxLoading = false;
      notifyListeners();
    }).onError((error, stackTrace) {
      isPrescriptionRxLoading = true;
      notifyListeners();
    });
  }
  getCurrentRx(BuildContext context)async{
    isCurrentRxLoading = true;
    currentRxList.clear();
    // drugList.clear();
    notifyListeners();
    medicineRepo.getCurrentRX().then((value) {
      currentRxList=value;
      // currentRxList.add(value);
      //drugList.addAll(value.drugs!);
      isCurrentRxLoading = false;
      notifyListeners();
    }).onError((error, stackTrace) {
      isCurrentRxLoading = true;
      notifyListeners();
    });
  }

  getPastRx(BuildContext context)async{
    isPastRxLoading = true;
    pastRxList.clear();
    // drugList.clear();
    notifyListeners();
    medicineRepo.getPastRX().then((value) {
      // pastRxList.add(value);
      pastRxList = value;
      isPastRxLoading = false;
      notifyListeners();
    }).onError((error, stackTrace) {
      isPastRxLoading = true;
      notifyListeners();
    });
  }
}

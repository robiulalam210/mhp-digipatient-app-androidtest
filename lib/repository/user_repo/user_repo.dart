import 'package:digi_patient/model/user_detail_model/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/network/base_api_service.dart';
import '../../data/network/network_api_service.dart';
import '../../resources/app_url.dart';
import '../../utils/user.dart';

class UserRepo {
  BaseApiService apiService = NetworkApiService();

  Future<UserModel> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    int? id = prefs.getInt(UserP.id);
    print(id);

    try {
      dynamic response = await apiService.getGetApiResponse(
        "${AppUrls.userUrl}$id",
      );

      print("object${response}");
      return UserModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> editUserData() async {
    final prefs = await SharedPreferences.getInstance();

    int? id = prefs.getInt(UserP.id);
    print(id);

    try {
      dynamic response = await apiService.getGetApiResponse(
        "${AppUrls.userUrl}$id",
      );

      return UserModel.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }
}

import 'dart:convert';
import 'package:get/get.dart';
import 'package:voice_record_test/api_services.dart';
import 'package:voice_record_test/login_model.dart';
import 'package:voice_record_test/success_model.dart';
import 'dart:developer' as developer;

class LoginController extends GetxController {
  var response = 0.obs;
  var message = ''.obs;
  var token = ''.obs;
  var userId = ''.obs;
  var isLoading = false.obs;
  var userName = ''.obs;
  var password = ''.obs;
  var isRemember = false.obs;

  getToken() async {
    isLoading.value = true;
    final data = jsonEncode({
      "Instance": '192.168.35.5:81',
      "UserId": 'aneel',
      "Password": '1',
      "PasswordHash": "",
      "DbName": 'farzana',
      "Port": '9018',
      "servername": ""
    });
    // developer.log(data.toString(), name: 'LoginController data');
    dynamic result;

    try {
      var feedback =
          await ApiServices.fetchDataRawBody(api: 'Gettoken', data: data);
      if (feedback != null) {
        result = LoginModel.fromJson(feedback);
        response.value = result.res;
        message.value = result.msg;
      }
    } finally {
      if (response.value == 1) {
        isLoading.value = false;
        token.value = result.loginToken;
        this.userId.value = result.userId;
        print(token.value);
        return true;
      } else {
        isLoading.value = false;
        print('error');
        return false;
      }
    }
  }

  attachFile(String file) async {
    isLoading.value = true;
    await getToken();
    final data = jsonEncode({
      "token": token.value,
      "EntityID": "",
      "EntityType": 0,
      "EntitySysDocID": "",
      "EntityDocName": "",
      "EntityDocDesc": "",
      "EntityDocKeyword": "",
      "EntityDocPath": "",
      "RowIndex": 0,
      "FileData": file
    });
    // developer.log(data.toString(), name: 'attach file data');
    dynamic result;

    try {
      var feedback =
          await ApiServices.fetchDataRawBody(api: 'AddAttachment', data: data);
      if (feedback != null) {
        result = SuccessModel.fromJson(feedback);
        response.value = result.res;
        if (result.res == 1) {
          isLoading.value = false;
          Get.snackbar('Success', 'Uploading successfull');
        } else {
          isLoading.value = false;
          Get.snackbar('Error', 'Uploading failed');
        }
      }
    } finally {}
  }
}

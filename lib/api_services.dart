import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:voice_record_test/api_constants.dart';

class ApiServices {
  static final client = http.Client();
  static Future fetchData({
    String? api,
  }) async {
    String baseUrl = Api.getBaseUrl();
    print('base url issss ==== ::::$baseUrl');
    print(baseUrl + api!);
    var responses = await client.post(
      Uri.parse('${baseUrl}$api'),
    );
    if (responses.statusCode == 200) {
      var jsonResponse = jsonDecode(responses.body);
      return jsonResponse;
    } else {
      throw Exception('Failed to load data');
    }
  }


  static Future fetchDataRawBody({String? api, String? data}) async {
    developer.log(data.toString(), name: 'ApiServices data');
    String baseUrl = Api.getBaseUrl();
    var responses = await client.post(
      Uri.parse('$baseUrl$api'),
      headers: {"Content-Type": "application/json"},
      body: data,
    );
    if (responses.statusCode == 200) {
      var jsonResponse = jsonDecode(responses.body);
      print(jsonResponse);
      return jsonResponse;
    } else {
      throw Exception('Failed to load data');
    }
  }

}

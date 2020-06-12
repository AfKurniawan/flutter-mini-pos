import 'package:flutter_mini_pos/src/login/models/login_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginService {

  Future<LoginModel> login(String url, var body) async {
    return await http.post(Uri.encodeFull(url),
        body: body,
        headers: {"Accept": "application/json"}).then((http.Response response) {
      final int statusCode = response.statusCode;
      print(response.body);

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return LoginModel.fromJson(json.decode(response.body));
    });
  }
}
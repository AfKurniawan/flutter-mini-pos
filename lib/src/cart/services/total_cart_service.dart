import 'package:flutter_mini_pos/src/cart/models/total_cart_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TotalCartService {
  Future<TotalCartModel> getTotalCart(String url, var body) async {
    return await http.post(Uri.encodeFull(url),
        body: body,
        headers: {"Accept": "application/json"}).then((http.Response response) {
      final int statusCode = response.statusCode;
      print("Get Total Cart ${response.body}");

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return TotalCartModel.fromJson(json.decode(response.body));
    });
  }
}
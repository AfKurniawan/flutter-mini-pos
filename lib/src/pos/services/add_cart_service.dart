import 'package:flutter_mini_pos/src/cart/models/cart_list_model.dart';
import 'package:flutter_mini_pos/src/products/models/products_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddCartService {
  Future<CartListModel> insertCart(String url, var body) async {
    return await http.post(Uri.encodeFull(url),
        body: body,
        headers: {"Accept": "application/json"}).then((http.Response response) {
      final int statusCode = response.statusCode;
      print("Insert To Cart ${response.body}");

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return CartListModel.fromJson(json.decode(response.body));
    });
  }
}
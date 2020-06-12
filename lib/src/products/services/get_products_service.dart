import 'package:flutter_mini_pos/src/products/models/products_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetProductService {
  Future<ProductsModel> getProduct(String url, var body) async {
    return await http.post(Uri.encodeFull(url),
        body: body,
        headers: {"Accept": "application/json"}).then((http.Response response) {
      final int statusCode = response.statusCode;
      print(response.body);

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return ProductsModel.fromJson(json.decode(response.body));
    });
  }
}
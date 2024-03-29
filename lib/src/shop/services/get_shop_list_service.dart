import 'package:flutter_mini_pos/src/register/models/register_model.dart';
import 'package:flutter_mini_pos/src/shop/models/shop_list_model.dart';
import 'package:flutter_mini_pos/src/shop/models/shop_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GetShopListService {


  Future<ShopList> getShopList(String url, var body) async {
    return await http.post(Uri.encodeFull(url),
        body: body,
        headers: {"Accept": "application/json"}).then((http.Response response) {
      final int statusCode = response.statusCode;
      print(response.body);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return ShopList.fromJson(json.decode(response.body));

    });

  }
}
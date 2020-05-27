import 'package:flutter_deltaprima_pos/src/pos/models/label_count_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LabelCountService {
  Future<LabelCountModel> getLabelCount(String url, var body) async {
    return await http.post(Uri.encodeFull(url),
        body: body,
        headers: {"Accept": "application/json"}).then((http.Response response) {
      final int statusCode = response.statusCode;
      print("Insert To Cart ${response.body}");

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return LabelCountModel.fromJson(json.decode(response.body));
    });
  }
}
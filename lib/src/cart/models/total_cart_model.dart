class TotalCartModel {
  bool error;
  String messages;
  Totals totals;

  TotalCartModel({this.error, this.messages, this.totals});

  TotalCartModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    messages = json['messages'];
    totals =
    json['totals'] != null ? new Totals.fromJson(json['totals']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['messages'] = this.messages;
    if (this.totals != null) {
      data['totals'] = this.totals.toJson();
    }
    return data;
  }
}

class Totals {
  String total;

  Totals({this.total});

  Totals.fromJson(Map<String, dynamic> json) {
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    return data;
  }
}

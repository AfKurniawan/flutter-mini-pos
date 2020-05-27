class LabelCountModel {
  bool error;
  String messages;
  Count count;

  LabelCountModel({this.error, this.messages, this.count});

  LabelCountModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    messages = json['messages'];
    count = json['count'] != null ? new Count.fromJson(json['count']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['messages'] = this.messages;
    if (this.count != null) {
      data['count'] = this.count.toJson();
    }
    return data;
  }
}

class Count {
  String count;

  Count({this.count});

  Count.fromJson(Map<String, dynamic> json) {
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    return data;
  }
}

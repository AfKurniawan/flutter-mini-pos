class ShopList {
  bool error;
  String messages;
  List<Shops> shops;

  ShopList({this.error, this.messages, this.shops});

  ShopList.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    messages = json['messages'];
    if (json['shops'] != null) {
      shops = new List<Shops>();
      json['shops'].forEach((v) {
        shops.add(new Shops.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['messages'] = this.messages;
    if (this.shops != null) {
      data['shops'] = this.shops.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Shops {
  String id;
  String dateCreated;
  String name;
  String address;
  String phone;
  String userId;

  Shops(
      {this.id,
        this.dateCreated,
        this.name,
        this.address,
        this.phone,
        this.userId});

  Shops.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateCreated = json['date_created'];
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date_created'] = this.dateCreated;
    data['name'] = this.name;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['user_id'] = this.userId;
    return data;
  }
}

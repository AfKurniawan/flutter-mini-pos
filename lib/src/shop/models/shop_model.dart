class ShopModel {
  bool error;
  String messages;
  Shop shop;

  ShopModel({this.error, this.messages, this.shop});

  ShopModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    messages = json['messages'];
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['messages'] = this.messages;
    if (this.shop != null) {
      data['shop'] = this.shop.toJson();
    }
    return data;
  }
}

class Shop {
  String id;
  String dateCreated;
  String name;
  String address;
  String phone;
  String userId;

  Shop(
      {this.id,
        this.dateCreated,
        this.name,
        this.address,
        this.phone,
        this.userId});

  Shop.fromJson(Map<String, dynamic> json) {
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



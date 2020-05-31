class LoginModel {
  bool error;
  String messages;
  User user;

  LoginModel({this.error, this.messages, this.user});

  LoginModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    messages = json['messages'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['messages'] = this.messages;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String id;
  String registerDate;
  String fullName;
  String email;
  String phone;
  String address;
  String password;
  String userType;
  String shopId;

  User(
      {this.id,
        this.registerDate,
        this.fullName,
        this.email,
        this.phone,
        this.address,
        this.password,
        this.userType,
        this.shopId});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    registerDate = json['register_date'];
    fullName = json['full_name'];
    email = json['email'];
    phone = json['phone'];
    address = json['address'];
    password = json['password'];
    userType = json['user_type'];
    shopId = json['shop_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['register_date'] = this.registerDate;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['password'] = this.password;
    data['user_type'] = this.userType;
    data['shop_id'] = this.shopId;
    return data;
  }
}

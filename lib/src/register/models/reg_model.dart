class RegisterModel {
  bool error;
  String messages;
  User user;

  RegisterModel({this.error, this.messages, this.user});

  RegisterModel.fromJson(Map<String, dynamic> json) {
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
  String password;

  User(
      {this.id,
        this.registerDate,
        this.fullName,
        this.email,
        this.phone,
        this.password});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    registerDate = json['register_date'];
    fullName = json['full_name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['register_date'] = this.registerDate;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    return data;
  }
}

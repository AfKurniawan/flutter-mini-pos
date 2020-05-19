
class Register {
  bool error;
  String messages;
  User user;

  Register({this.error, this.messages, this.user});

//  factory Register.fromJson(Map<String, dynamic> json){
//    return Register(
//        error: json['error'],
//        messages: json['messages'],
//        user: User.fromJson(json['user'])
//    );
//  }



}

class User {
  String id;
  String registerDate;
  String fullName;
  String email;
  String password;
  String phone;

  User({this.registerDate,
    this.id,
    this.fullName,
    this.email,
    this.password,
    this.phone});

  User.fromJson(Map<String, dynamic> json) {
    registerDate = json['register_date'];
    id      = json['id'];
    fullName = json['full_name'];
    email = json['email'];
    password = json['password'];
    phone = json['phone'];
  }

}
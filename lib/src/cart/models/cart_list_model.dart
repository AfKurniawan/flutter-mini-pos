class CartListModel {
  bool error;
  String messages;
  List<Cart> cart;

  CartListModel({this.error, this.messages, this.cart});

  CartListModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    messages = json['messages'];
    if (json['cart'] != null) {
      cart = new List<Cart>();
      json['cart'].forEach((v) {
        cart.add(new Cart.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['messages'] = this.messages;
    if (this.cart != null) {
      data['cart'] = this.cart.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cart {
  String id;
  String name;
  String image;
  String sellingPrice;
  String quantity;
  String total;

  Cart(
      {this.id,
        this.name,
        this.image,
        this.sellingPrice,
        this.quantity,
        this.total});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    sellingPrice = json['selling_price'];
    quantity = json['quantity'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['selling_price'] = this.sellingPrice;
    data['quantity'] = this.quantity;
    data['total'] = this.total;
    return data;
  }
}

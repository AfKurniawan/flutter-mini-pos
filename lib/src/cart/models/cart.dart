class Carts {
  bool error;
  String messages;
  Count count;
  List<Cart> cart;

  Carts({this.error, this.messages, this.count, this.cart});

  Carts.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    messages = json['messages'];
    count = json['count'] != null ? new Count.fromJson(json['count']) : null;
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
    if (this.count != null) {
      data['count'] = this.count.toJson();
    }
    if (this.cart != null) {
      data['cart'] = this.cart.map((v) => v.toJson()).toList();
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

class Cart {
  String id;
  String date;
  String productId;
  String quantity;
  String shopId;
  String userId;
  String price;
  String total;
  String receiveAmount;
  String changeAmount;

  Cart(
      {this.id,
        this.date,
        this.productId,
        this.quantity,
        this.shopId,
        this.userId,
        this.price,
        this.total,
        this.receiveAmount,
        this.changeAmount});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    productId = json['product_id'];
    quantity = json['quantity'];
    shopId = json['shop_id'];
    userId = json['user_id'];
    price = json['price'];
    total = json['total'];
    receiveAmount = json['receive_amount'];
    changeAmount = json['change_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['shop_id'] = this.shopId;
    data['user_id'] = this.userId;
    data['price'] = this.price;
    data['total'] = this.total;
    data['receive_amount'] = this.receiveAmount;
    data['change_amount'] = this.changeAmount;
    return data;
  }
}

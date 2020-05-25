class Products {
  bool error;
  String messages;
  Item item;

  Products({this.error, this.messages, this.item});

  Products.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    messages = json['messages'];
    item = json['item'] != null ? new Item.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['messages'] = this.messages;
    if (this.item != null) {
      data['item'] = this.item.toJson();
    }
    return data;
  }
}

class Item {
  String id;
  String name;
  String barcode;
  String image;
  String variant;
  String purchasePrice;
  String sellingPrice;
  String shopId;

  Item(
      {this.id,
        this.name,
        this.barcode,
        this.image,
        this.variant,
        this.purchasePrice,
        this.sellingPrice,
        this.shopId});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    barcode = json['barcode'];
    image = json['image'];
    variant = json['variant'];
    purchasePrice = json['purchase_price'];
    sellingPrice = json['selling_price'];
    shopId = json['shop_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['barcode'] = this.barcode;
    data['image'] = this.image;
    data['variant'] = this.variant;
    data['purchase_price'] = this.purchasePrice;
    data['selling_price'] = this.sellingPrice;
    data['shop_id'] = this.shopId;
    return data;
  }
}

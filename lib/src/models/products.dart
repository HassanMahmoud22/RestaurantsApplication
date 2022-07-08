class Products {
  final String? id;
  final String? productName;
  final String? productDescription;
   final String? price;
  final String? photo;

  Products({this.id, this.productName, this.productDescription, this.price, this.photo});

  Products.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        productName = json["productName"],
        productDescription = json["productDescription"],
        price = json["price"],
        photo = json["photo"];
}

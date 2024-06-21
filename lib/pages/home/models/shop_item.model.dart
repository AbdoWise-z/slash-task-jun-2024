class ShopItemModel {
  int? id;
  String? name;
  double? price;
  String? image;
  bool liked;

  ShopItemModel({this.id, this.name, this.price, this.image, this.liked = false});

  ShopItemModel.fromJson(Map<String, dynamic> json)
      : liked = json['liked'] ?? false {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['image'] = image;
    data['liked'] = liked;
    return data;
  }

  ShopItemModel copyWith({
    int? id,
    String? name,
    double? price,
    String? image,
    bool? liked,
  }) {
    return ShopItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      liked: liked ?? this.liked,
    );
  }
}

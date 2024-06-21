class OfferModel {
  String? image;
  int? id;

  OfferModel({this.image, this.id});

  OfferModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['id'] = id;
    return data;
  }
}
class ProductDetails {
  final imgUrls;
  final description;
  ProductDetails({this.imgUrls, this.description});

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    List result = [];
    //go through imgs
    for (var el in json['media']['images']) {
      result.add('https://' + el['url']);
    }

    return ProductDetails(
        imgUrls: result, description: json['description']);
  }
}

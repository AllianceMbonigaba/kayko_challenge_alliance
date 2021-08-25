class ProductLst {
  final products;
  

  ProductLst({
    this.products,
    
  });

  factory ProductLst.fromJson(Map<String, dynamic> json) {
    return ProductLst(
      products: json['products'],
      
    );
  }
}

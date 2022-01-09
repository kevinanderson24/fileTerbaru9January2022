class ProductModel{
  int price;
  String name;
  String description;
  String id;
  String url;
  

  ProductModel({this.price, this.name, this.description, this.id, this.url});

  //RECEIVE data from server
  factory ProductModel.fromMap(map){
    return ProductModel(
      price: map['price'],
      name: map['name'],
      description: map['description'],
      id: map['id'],
      url: map['url'],
    );
  }
  
 

  //SENDING data to our server
  Map<String, dynamic> toMap(){
    return{
      'price': price,
      'name': name,
      'description': description,
      'id': id,
      'url': url,
    };
  }
}
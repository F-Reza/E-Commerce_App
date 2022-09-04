const String cartProductId = 'productId';
const cartProductName = 'productName';
const cartProductPrice = 'productPrice';
const cartProductQuantity = 'productQuantity';
const cartProductStock = 'productStock';
const cartProductCategory = 'category';
const cartProductImage = 'productImage';


class CartModel {
  String? productId, productName,  imageUrl, category;
  num salePrice, quantity, stock;


  CartModel(
      {this.productId,
      this.productName,
      this.imageUrl,
      required this.salePrice,
      required this.stock,
      required this.category,
      this.quantity = 1});

  Map<String, dynamic> toMap() => {
    cartProductId : productId,
    cartProductName :productName,
    cartProductPrice :salePrice,
    cartProductQuantity :quantity,
    cartProductStock :stock,
    cartProductCategory :category,
    cartProductImage :imageUrl,
  };

  factory CartModel.fromMap(Map<String, dynamic> map) => CartModel(
    productId: map[cartProductId],
    productName: map[cartProductName],
    salePrice: map[cartProductPrice],
    quantity: map[cartProductQuantity],
    stock: map[cartProductStock],
    category: map[cartProductCategory],
    imageUrl: map[cartProductImage],
  );

}


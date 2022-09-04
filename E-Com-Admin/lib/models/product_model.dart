const productId = 'id';
const productName = 'product';
const productCategory = 'category';
const productSalesPrice = 'sale_price';
const productDescription = 'description';
const productImageUrl = 'image';
const productFeatured = 'featured';
const productAvailable = 'available';
const productStock = 'stock';

class ProductModel {
  String? id;
  String? name;
  String? category;
  String? description;
  String? imageUrl;
  num salesPrice, stock;
  bool featured;
  bool available;

  ProductModel({
    this.id,
    this.name,
    this.category,
    this.description,
    this.imageUrl,
    this.salesPrice = 0.0,
    this.featured = true,
    this.available = true,
    this.stock = 0,
  });

  Map<String, dynamic> toMap() => {
    productId: id,
    productName: name,
    productCategory: category,
    productSalesPrice: salesPrice,
    productDescription: description,
    productImageUrl: imageUrl,
    productFeatured: featured,
    productAvailable: available,
    productStock: stock,
  };

  factory ProductModel.fromMap(Map<String, dynamic> map) => ProductModel(
    id: map[productId],
    name: map[productName],
    category: map[productCategory],
    salesPrice: map[productSalesPrice],
    description: map[productDescription],
    imageUrl: map[productImageUrl],
    featured: map[productFeatured],
    available: map[productAvailable],
    stock: map[productStock],
  );
}

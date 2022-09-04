import 'date_model.dart';

const purchaseId = 'id';
const purchaseProductId = 'productId';
const purchaseDate = 'date';
const purchasePrice = 'price';
const purchaseQuantity = 'quantity';

class PurchaseModel {
  String? id;
  String? productId;
  num price;
  num quantity;
  DateModel dateModel;

  PurchaseModel({
    this.id,
    this.productId,
    required this.dateModel,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      purchaseId :id,
      purchaseProductId :productId,
      purchaseDate :dateModel.toMap(),
      purchasePrice :price*quantity,
      purchaseQuantity :quantity,
    };
  }

  factory PurchaseModel.fromMap(Map<String, dynamic> map) => PurchaseModel(
        id: map[purchaseId],
        productId: map[purchaseProductId],
        dateModel: DateModel.fromMap(map[purchaseDate]),
        price: map[purchasePrice],
        quantity: map[purchaseQuantity],
      );
}

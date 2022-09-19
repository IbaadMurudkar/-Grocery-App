import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  final String id, title, imageUrl, productCategoryName;
  final double price, salePrice;
  final bool isPiece;
  final bool isOnSale;

  ProductModel(
      {required this.id,
      required this.title,
      required this.imageUrl,
      required this.productCategoryName,
      required this.price,
      required this.salePrice,
      required this.isOnSale,
      required this.isPiece});
}

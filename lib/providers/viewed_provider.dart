import 'package:ecommerce_app/models/wishlist_model.dart';
import 'package:flutter/material.dart';

import '../models/viewed_model.dart';

class ViewedProvider with ChangeNotifier {
  Map<String, ViewedModel> viewedItems = {};

  Map<String, ViewedModel> get getViewedItems {
    return viewedItems;
  }

  void addProductToHistory({required String productId}) {
    viewedItems.putIfAbsent(productId,
        () => ViewedModel(id: DateTime.now().toString(), productId: productId));

    notifyListeners();
  }

  void clearHistory() {
    viewedItems.clear();
    notifyListeners();
  }
}

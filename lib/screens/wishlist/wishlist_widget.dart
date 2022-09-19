import 'package:ecommerce_app/widgets/heart_btn.dart';
import 'package:ecommerce_app/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../../inner_screens/product_detail.dart';
import '../../models/products_model.dart';
import '../../models/wishlist_model.dart';
import '../../providers/products_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/utils.dart';

class WishlistWidget extends StatelessWidget {
  const WishlistWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final wishlistModel = Provider.of<WishlistModel>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct =
        productProvider.fndProdId(wishlistModel.productId);
    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;

    bool? _isInWishlist =
    wishlistProvider.getWishlistItems.containsKey(getCurrentProduct.id);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, ProductDetailScreen.routeName,
              arguments: wishlistModel.productId);
        },
        child: Container(
          height: size.height * 0.2,
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color, width: 2)),
          child: Row(
            children: [
              Flexible(
                flex: 2,
                child: Container(
                  margin: const EdgeInsets.only(left: 8),
                  // width: size.width * 0.2,
                  //height: size.height * 0.25,
                  child: FancyShimmerImage(
                    imageUrl: getCurrentProduct.imageUrl,
                    boxFit: BoxFit.fill,
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(IconlyLight.bag2)),
                          HeartBTN(
                            productId: getCurrentProduct.id,
                            isInWishlist: _isInWishlist,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                        child: TextWidget(
                      text: getCurrentProduct.title,
                      color: color,
                      textSize: 20,
                      isTitle: true,
                    )),
                    TextWidget(
                      text: '\$${usedPrice.toStringAsFixed(2)}',
                      color: Colors.green,
                      textSize: 20,
                      isTitle: true,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

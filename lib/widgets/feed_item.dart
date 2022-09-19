import 'package:ecommerce_app/inner_screens/product_detail.dart';
import 'package:ecommerce_app/models/products_model.dart';
import 'package:ecommerce_app/services/global_methods.dart';
import 'package:ecommerce_app/widgets/heart_btn.dart';
import 'package:ecommerce_app/widgets/price_widget.dart';
import 'package:ecommerce_app/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../consts/firebase_const.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/utils.dart';

class FeedsWidget extends StatefulWidget {
  const FeedsWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<FeedsWidget> createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    quantityController.text = '1';
    super.initState();
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final productModel = Provider.of<ProductModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    bool? isInCart = cartProvider.getCartItems.containsKey(productModel.id);
    bool? _isInWishlist =
        wishlistProvider.wishlistItems.containsKey(productModel.id);
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, ProductDetailScreen.routeName,
                arguments: productModel.id);
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              FancyShimmerImage(
                imageUrl: productModel.imageUrl,
                width: size.width * 0.2,
                height: size.width * 0.21,
                boxFit: BoxFit.fill,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextWidget(
                      text: productModel.title,
                      color: color,
                      textSize: 18,
                      isTitle: true,
                    ),
                  ),
                  HeartBTN(
                    productId: productModel.id,
                    isInWishlist: _isInWishlist,
                  ),
                ],
              ),
              Row(
                children: [
                  PriceWidget(
                    salePrice: productModel.salePrice,
                    price: productModel.price,
                    textPrice: quantityController.text,
                    isOnSale: false,
                  ),
                  const SizedBox(width: 3),
                  Row(
                    children: [
                      TextWidget(
                        text: productModel.isPiece ? 'Piece' : 'KG',
                        color: color,
                        textSize: 18,
                        isTitle: true,
                      ),
                    ],
                  ),
                  Flexible(
                      child: TextFormField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    controller: quantityController,
                    key: const ValueKey(10),
                    maxLines: 1,
                    enabled: true,
                    onChanged: (valueee) {
                      setState(() {});
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9.]'))
                    ],
                  )),
                ],
              ),
              TextButton(
                  onPressed: isInCart
                      ? null
                      : () async{
                    final User? user =
                        authInstance.currentUser;
                    if (user == null) {
                      GlobalMethods.errorDialog(
                          subtitle:
                          'No user found, Please Login first',
                          context: context);
                      return;
                    }

                  await  GlobalMethods.addToCart(
                        productId: productModel.id,
                        quantity: int.parse(quantityController.text),
                        context: context);
                    await cartProvider.fetchCart();
                          // cartProvider.addProductsToCart(
                          //     productId: productModel.id,
                          //     quantity: int.parse(quantityController.text));
                        },
                  child: Text(
                    isInCart ? 'In Cart' : 'Add to Cart',
                    style:
                        TextStyle(color: isInCart ? Colors.red : Colors.orange),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

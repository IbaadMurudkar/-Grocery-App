import 'package:ecommerce_app/widgets/heart_btn.dart';
import 'package:ecommerce_app/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../consts/firebase_const.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../providers/viewed_provider.dart';
import '../providers/wishlist_provider.dart';
import '../services/global_methods.dart';
import '../services/utils.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/ProductDetailsScreen';

  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
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
    final cartProvider = Provider.of<CartProvider>(context);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct = productProvider.fndProdId(productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final viewedProvider = Provider.of<ViewedProvider>(context);
    bool? _isInWishlist =
        wishlistProvider.wishlistItems.containsKey(getCurrentProduct.id);

    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    double totalPrice = usedPrice * int.parse(quantityController.text);
    bool? isInCart =
        cartProvider.getCartItems.containsKey(getCurrentProduct.id);
    return WillPopScope(
      onWillPop: () async {
        viewedProvider.addProductToHistory(productId: productId);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Category Screen'),
          backgroundColor: Colors.orange[400],
        ),
        body: Column(
          children: [
            Flexible(
              flex: 2,
              child: FancyShimmerImage(
                imageUrl: getCurrentProduct.imageUrl,
                boxFit: BoxFit.scaleDown,
                width: size.width,
              ),
            ),
            Flexible(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: TextWidget(
                              text: getCurrentProduct.title,
                              color: color,
                              textSize: 25,
                              isTitle: true,
                            )),
                            HeartBTN(
                              productId: getCurrentProduct.id,
                              isInWishlist: _isInWishlist,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 20, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextWidget(
                                text: '\$${usedPrice.toStringAsFixed(2)}/',
                                color: Colors.green,
                                isTitle: true,
                                textSize: 22),
                            TextWidget(
                                text:
                                    getCurrentProduct.isPiece ? 'Piece' : '/kg',
                                color: color,
                                textSize: 18),
                            const SizedBox(width: 8),
                            Visibility(
                                visible:
                                    getCurrentProduct.isOnSale ? true : false,
                                child: Text(
                                  '\$${getCurrentProduct.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: color,
                                      decoration: TextDecoration.lineThrough),
                                )),
                            const Spacer(),
                            Material(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextWidget(
                                    text: 'Free Delivery',
                                    color: Colors.white,
                                    textSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Material(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  onTap: () {
                                    if (quantityController.text == '1') {
                                      return;
                                    } else {
                                      setState(() {
                                        quantityController.text = (int.parse(
                                                    quantityController.text) -
                                                1)
                                            .toString();
                                      });
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: const Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: Icon(
                                      CupertinoIcons.minus,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                              flex: 1,
                              child: TextField(
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                controller: quantityController,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[ 0-9]')),
                                ],
                                onChanged: (v) {
                                  setState(() {
                                    if (v.isEmpty) {
                                      quantityController.text = '1';
                                    } else {
                                      return;
                                    }
                                  });
                                },
                              )),
                          Flexible(
                            flex: 2,
                            child: Material(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    quantityController.text =
                                        (int.parse(quantityController.text) + 1)
                                            .toString();
                                  });
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(
                                    CupertinoIcons.plus,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: size.width,
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.orange[400],
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                    text: 'Total',
                                    isTitle: true,
                                    color: Colors.white,
                                    textSize: 22),
                                const SizedBox(
                                  height: 5,
                                ),
                                FittedBox(
                                  child: Row(
                                    children: [
                                      TextWidget(
                                          text:
                                              '\$${totalPrice.toStringAsFixed(2)}/',
                                          isTitle: true,
                                          color: color,
                                          textSize: 22),
                                      TextWidget(
                                          text:
                                              ' ${quantityController.text} kg',
                                          isTitle: false,
                                          color: color,
                                          textSize: 22),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                            Material(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: isInCart
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
                                            productId: getCurrentProduct.id,
                                            quantity: int.parse(
                                                quantityController.text),
                                            context: context);
                                        await cartProvider.fetchCart();
                                        // cartProvider.addProductsToCart(
                                        //     productId: getCurrentProduct.id,
                                        //     quantity: int.parse(
                                        //         quantityController.text));
                                      },
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextWidget(
                                      text:
                                          isInCart ? 'In Cart' : 'Add to Cart',
                                      color: Colors.white,
                                      textSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}

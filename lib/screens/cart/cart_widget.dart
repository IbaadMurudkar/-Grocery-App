import 'package:ecommerce_app/models/cart_model.dart';
import 'package:ecommerce_app/providers/products_provider.dart';
import 'package:ecommerce_app/widgets/heart_btn.dart';
import 'package:ecommerce_app/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../inner_screens/product_detail.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/utils.dart';

class CartWidget extends StatefulWidget {
  const CartWidget({Key? key, required this.q}) : super(key: key);
  final int q;

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final _quantityTextController = TextEditingController();

  @override
  void initState() {
    _quantityTextController.text = widget.q.toString();
    super.initState();
  }

  @override
  void dispose() {
    _quantityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final cartModel = Provider.of<CartModel>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct = productProvider.fndProdId(cartModel.productId);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    bool? isInWishlist =
        wishlistProvider.wishlistItems.containsKey(getCurrentProduct.id);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetailScreen.routeName,
            arguments: cartModel.productId);
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).cardColor),
                child: Row(
                  children: [
                    Container(
                      width: size.width * 0.25,
                      height: size.width * 0.25,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12)),
                      child: FancyShimmerImage(
                        imageUrl: getCurrentProduct.imageUrl,
                        boxFit: BoxFit.fill,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextWidget(
                          text: getCurrentProduct.title,
                          color: color,
                          textSize: 18,
                          isTitle: true,
                        ),
                        const SizedBox(
                          height: 14,
                        ),
                        SizedBox(
                          width: size.width * 0.3,
                          child: Row(
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
                                        if (_quantityTextController.text ==
                                            '1') {
                                          return;
                                        } else {
                                          cartProvider.reduceQuantityByOne(
                                              cartModel.productId);
                                          setState(() {
                                            _quantityTextController
                                                .text = (int.parse(
                                                        _quantityTextController
                                                            .text) -
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
                                    keyboardType: TextInputType.number,
                                    controller: _quantityTextController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[ 0-9]')),
                                    ],
                                    onChanged: (v) {
                                      setState(() {
                                        if (v.isEmpty) {
                                          _quantityTextController.text = '1';
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
                                      cartProvider.increaseQuantityByOne(
                                          cartModel.productId);
                                      setState(() {
                                        _quantityTextController.text =
                                            (int.parse(_quantityTextController
                                                        .text) +
                                                    1)
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
                        )
                      ],
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              await cartProvider.removeOneItem(
                                  cartId: cartModel.id,
                                  productId: cartModel.productId,
                                  quantity: cartModel.quantity);
                            },
                            child: const Icon(
                              CupertinoIcons.delete,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 5),
                          HeartBTN(
                            productId: getCurrentProduct.id,
                            isInWishlist: isInWishlist,
                          ),
                          const SizedBox(height: 3),
                          TextWidget(
                            text:
                                '\$${(usedPrice * int.parse(_quantityTextController.text)).toStringAsFixed(2)}',
                            color: Colors.green,
                            textSize: 18,
                            isTitle: true,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

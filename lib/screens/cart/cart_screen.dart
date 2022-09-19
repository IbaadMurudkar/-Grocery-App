import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/firebase_const.dart';
import 'package:ecommerce_app/providers/orderProvider.dart';
import 'package:ecommerce_app/screens/cart/cart_widget.dart';
import 'package:ecommerce_app/widgets/empty_screen.dart';
import 'package:ecommerce_app/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../providers/cart_provider.dart';

import '../../providers/orderProvider.dart';

import '../../providers/products_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';

class CartsScreen extends StatefulWidget {
  const CartsScreen({Key? key}) : super(key: key);

  @override
  State<CartsScreen> createState() => _CartsScreenState();
}

class _CartsScreenState extends State<CartsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final cartProvider = Provider.of<CartProvider>(context);

    final cartItemsList =
        cartProvider.getCartItems.values.toList().reversed.toList();
    return cartItemsList.isEmpty
        ? const EmptyScreen(
            title: 'No item in your Cart',
            imagePath: 'assets/images/cart.png',
            subtitle: 'Add something to make me happy :)',
            buttontext: 'Shop now',
          )
        : Scaffold(
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: IconButton(
                      onPressed: () {
                        GlobalMethods.warningDialog(
                            title: 'Empty your Cart?',
                            subtitle: 'Are you Sure?',
                            fct: () async {
                              await cartProvider.clearOnlineCart();
                              cartProvider.clearLocalCart();
                            },
                            context: context);
                      },
                      icon: const Icon(
                        IconlyBroken.delete,
                        color: Colors.white,
                        size: 30,
                      )),
                )
              ],
              title: TextWidget(
                text: 'Cart (${cartItemsList.length})',
                color: Colors.white,
                textSize: 22,
                isTitle: true,
              ),
              backgroundColor: Colors.orange[400],
            ),
            body: Column(
              children: [
                _checkout(ctx: context),
                Expanded(
                  child: ListView.builder(
                      itemCount: cartItemsList.length,
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: cartItemsList[index],
                            child: CartWidget(
                              q: cartItemsList[index].quantity,
                            ));
                      }),
                ),
              ],
            ),
          );
  }

  Widget _checkout({required BuildContext ctx}) {
    final Color color = Utils(ctx).color;
    Size size = Utils(ctx).getScreenSize;
    final cartProvider = Provider.of<CartProvider>(ctx);
    final productProvider = Provider.of<ProductsProvider>(ctx);
    final ordersProvider = Provider.of<OrdersProvider>(context);
    double total = 0.0;
    cartProvider.getCartItems.forEach((key, value) {
      final getCurrProduct = productProvider.fndProdId(value.productId);

      total += (getCurrProduct.isOnSale
              ? getCurrProduct.salePrice
              : getCurrProduct.price) *
          value.quantity;
    });
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () async {
                  final User? user = authInstance.currentUser;
                  final orderId = const Uuid().v4();
                  final productProvider =
                      Provider.of<ProductsProvider>(context, listen: false);

                  cartProvider.getCartItems.forEach((key, value) async {
                    final getCurrentProduct =
                        productProvider.fndProdId(value.productId);
                    try {
                      await FirebaseFirestore.instance
                          .collection('orders')
                          .doc()
                          .set({
                        'orderId': orderId,
                        'userId': user!.uid,
                        'productId': value.productId,
                        'price': (getCurrentProduct.isOnSale
                                ? getCurrentProduct.salePrice
                                : getCurrentProduct.price) *
                            value.quantity,
                        'totalPrice': total,
                        'quantity': value.quantity,
                        'imageUrl': getCurrentProduct.imageUrl,
                        'name': user.displayName,
                        'orderDate': Timestamp.now(),
                      });
                    } catch (error) {
                      GlobalMethods.errorDialog(
                          subtitle: error.toString(), context: context);
                    } finally {}
                  });
                  await cartProvider.clearOnlineCart();
                  cartProvider.clearLocalCart();
                  ordersProvider.fetchOrders();
                  await Fluttertoast.showToast(
                    msg: "Your Order has been Placed",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextWidget(
                      text: 'Order Now', color: Colors.white, textSize: 20),
                ),
              ),
            ),
            FittedBox(
              child: TextWidget(
                text: 'Total : \$${total.toStringAsFixed(2)}',
                color: color,
                textSize: 18,
                isTitle: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}

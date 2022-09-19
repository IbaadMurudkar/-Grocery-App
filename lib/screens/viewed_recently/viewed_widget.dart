import 'package:ecommerce_app/models/viewed_model.dart';
import 'package:ecommerce_app/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../../consts/firebase_const.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';
import '../../services/global_methods.dart';
import '../../services/utils.dart';

class ViewedWidget extends StatefulWidget {
  const ViewedWidget({Key? key}) : super(key: key);

  @override
  State<ViewedWidget> createState() => _ViewedWidgetState();
}

class _ViewedWidgetState extends State<ViewedWidget> {
  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final viewedModel = Provider.of<ViewedModel>(context);
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct = productProvider.fndProdId(viewedModel.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    bool? isInCart =
        cartProvider.getCartItems.containsKey(getCurrentProduct.id);
    double usedPrice = getCurrentProduct.isOnSale
        ? getCurrentProduct.salePrice
        : getCurrentProduct.price;
    return GestureDetector(
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => const ProductDetailScreen()));
      },
      child: ListTile(
        title: TextWidget(
          text: getCurrentProduct.title,
          color: color,
          textSize: 18,
          isTitle: true,
        ),
        trailing: Material(
          color: Colors.green,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: isInCart
                ? null
                : ()async {
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
                  quantity: 1,
                  context: context);
              await cartProvider.fetchCart();
              // cartProvider.addProductsToCart(
              //     productId: getCurrentProduct.id,
              //     quantity: 1);
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(
                isInCart ? Icons.check : IconlyBold.plus,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
        subtitle: Text('\$${usedPrice.toStringAsFixed(2)}'),
        leading: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: FancyShimmerImage(
            imageUrl: getCurrentProduct.imageUrl,
            width: size.width * 0.2,
            boxFit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}

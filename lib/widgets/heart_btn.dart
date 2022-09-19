import 'package:ecommerce_app/consts/firebase_const.dart';
import 'package:ecommerce_app/providers/wishlist_provider.dart';
import 'package:ecommerce_app/services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../services/utils.dart';

class HeartBTN extends StatefulWidget {

   HeartBTN(
      {Key? key, required this.isInWishlist, required this.productId})
      : super(key: key);
  final bool? isInWishlist;
  final String productId;

  @override
  State<HeartBTN> createState() => _HeartBTNState();
}

class _HeartBTNState extends State<HeartBTN> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct = productProvider.fndProdId(widget.productId);
    return GestureDetector(
        onTap: () async{
          setState(() {
            loading = true;
          });
          try {
            final User? user = authInstance.currentUser;

            if (user == null) {
              GlobalMethods.errorDialog(
                  subtitle: 'No user found, Please login first',
                  context: context);
              return;
            }
            if (widget.isInWishlist == false && widget.isInWishlist != null) {
          await    GlobalMethods.addToWishlist(
                  productId: widget.productId, context: context);
            } else {
            await  wishlistProvider.removeOneItem(
                productId: widget.productId,
                wishlistId:
                    wishlistProvider.getWishlistItems[getCurrentProduct.id]!.id,
              );
            }
          await  wishlistProvider.fetchWishlist();
            setState(() {
              loading = false;
            });
          } catch (error) {
            GlobalMethods.errorDialog(subtitle: 'error', context: context);
          } finally {
            setState(() {
              loading = false;
            });
          }
        },
        child:loading? const SizedBox(
            height: 15,
            width: 15,
            child: CircularProgressIndicator()) : Icon(
          widget.isInWishlist != null && widget.isInWishlist == true
              ? IconlyBold.heart
              : IconlyLight.heart,
          color:
              widget.isInWishlist != null && widget.isInWishlist == true ? Colors.red : color,
        ));
  }
}

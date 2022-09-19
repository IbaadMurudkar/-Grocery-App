import 'package:ecommerce_app/providers/wishlist_provider.dart';
import 'package:ecommerce_app/screens/wishlist/wishlist_widget.dart';
import 'package:ecommerce_app/services/global_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../../services/utils.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = "/WishlistScreen";
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemsList =
    wishlistProvider.getWishlistItems.values.toList().reversed.toList();
    return wishlistItemsList.isEmpty
        ? const EmptyScreen(
            title: 'Your WishList is Empty',
            imagePath: 'assets/images/history.png',
            subtitle: 'No products have been Viewed yet!',
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
                            title: 'Empty your WishList?',
                            subtitle: 'Are you Sure?',
                            fct: ()async{
                              await wishlistProvider.clearOnlineWishlist();
                              wishlistProvider.clearLocalWishlist();},
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
                text:'Wishlist (${wishlistItemsList.length})',
                color: Colors.white,
                textSize: 22,
                isTitle: true,
              ),
              backgroundColor: Colors.orange[400],
            ),
            body: MasonryGridView.count(
              itemCount: wishlistItemsList.length,
              crossAxisCount: 2,
              // mainAxisSpacing: 16,
              // crossAxisSpacing: 20,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider.value(
                    value: wishlistItemsList[index],
                    child: const WishlistWidget());
              },
            ),
          );
  }
}

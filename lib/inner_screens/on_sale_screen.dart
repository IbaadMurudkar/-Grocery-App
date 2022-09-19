import 'package:ecommerce_app/widgets/empty_product_widget.dart';
import 'package:ecommerce_app/widgets/on_sale_widget.dart';
import 'package:ecommerce_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/products_model.dart';
import '../providers/products_provider.dart';
import '../services/utils.dart';

class OnSaleScreen extends StatelessWidget {
  const OnSaleScreen({Key? key}) : super(key: key);
  static const routeName = "/OnSaleScreen";
  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> productsOnSale = productProvider.getOnSaleProducts;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange[400],
          title: TextWidget(
            text: 'Products On Sale',
            color: Colors.white,
            textSize: 22,
            isTitle: true,
          )),
      body: productsOnSale.isEmpty
          ?const EmptyProductWidget(text:  "No Products on Sale Yet! \n Stay Tuned",)
          : GridView.count(
              crossAxisCount: 2,
              childAspectRatio: size.width / (size.height * 0.45),
              children: List.generate(productsOnSale.length, (index) {
                return  ChangeNotifierProvider.value(
                    value: productsOnSale[index], child:const OnSaleWidget());
              }),
            ),
    );
  }
}

import 'package:ecommerce_app/inner_screens/product_detail.dart';
import 'package:ecommerce_app/widgets/text_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/orders_model.dart';
import '../../providers/products_provider.dart';
import '../../services/utils.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({Key? key}) : super(key: key);

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  late String orderDateToShow;

  void didChangeDependencies() {
    final ordersModel = Provider.of<OrderModel>(context);
    var orderDate = ordersModel.orderDate.toDate();
    orderDateToShow = '${orderDate.day}/${orderDate.month}/${orderDate.year}';
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ordersModel = Provider.of<OrderModel>(context);
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct = productProvider.fndProdId(ordersModel.productId);
    final size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ProductDetailScreen()));
      },
      child: ListTile(
        title: TextWidget(
          text: '${getCurrentProduct.title}',
          color: color,
          textSize: 18,
          isTitle: true,
        ),
        trailing: TextWidget(text: orderDateToShow, color: color, textSize: 18),
        subtitle: Text(
            'Paid: \$${double.parse(ordersModel.price).toStringAsFixed(2)}'),
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

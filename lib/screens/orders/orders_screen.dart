import 'package:ecommerce_app/screens/orders/orders_widgetr.dart';
import 'package:ecommerce_app/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/orderProvider.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    final ordersProvider = Provider.of<OrdersProvider>(context);
    final orderList = ordersProvider.getOrders;
    return FutureBuilder(
        future: ordersProvider.fetchOrders(),
        builder: (context, snapshot) {
          return orderList.isEmpty
              ? const EmptyScreen(
                  title: "You didn't placed any Order yet ",
                  imagePath: 'assets/images/cart.png',
                  subtitle: 'Order something and make me happy :)',
                  buttontext: 'Shop now',
                )
              : Scaffold(
                  appBar: AppBar(
                    title: TextWidget(
                      text: 'Your Orders (${orderList.length})',
                      color: Colors.white,
                      textSize: 22,
                      isTitle: true,
                    ),
                    backgroundColor: Colors.orange[400],
                  ),
                  body: ListView.separated(
                      itemBuilder: (context, index) {
                        return ChangeNotifierProvider.value(
                            value: orderList[index],
                            child: const OrdersWidget());
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(
                          thickness: 2,
                          color: color,
                        );
                      },
                      itemCount: orderList.length),
                );
        });
  }
}

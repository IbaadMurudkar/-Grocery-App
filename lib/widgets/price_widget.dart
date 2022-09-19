import 'package:ecommerce_app/services/utils.dart';
import 'package:ecommerce_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget(
      {Key? key,
      required this.salePrice,
      required this.price,
      required this.textPrice,
      required this.isOnSale})
      : super(key: key);

  final double salePrice;
  final double price;
  final String textPrice;
  final bool isOnSale;

  @override
  Widget build(BuildContext context) {
    double userPrice = isOnSale ? salePrice : price;
    final Color color = Utils(context).color;
    return FittedBox(
      child: Row(
        children: [
          TextWidget(
            text: '\$${(userPrice * int.parse(textPrice)).toString()}',
            color: Colors.green,
            textSize: 22,
          ),
          const SizedBox(width: 5),
          Visibility(
            visible: isOnSale ? true : false,
            child: Text(
              '\$${(price * int.parse(textPrice)).toString()}',
              style: TextStyle(
                  fontSize: 15,
                  color: color,
                  decoration: TextDecoration.lineThrough),
            ),
          )
        ],
      ),
    );
  }
}

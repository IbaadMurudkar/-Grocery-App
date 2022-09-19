import 'package:ecommerce_app/services/utils.dart';
import 'package:flutter/material.dart';

class EmptyProductWidget extends StatelessWidget {
  const EmptyProductWidget({Key? key, required this.text}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    Color color = Utils(context).color;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Image.asset('assets/images/box.png'),
            Text(
             text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold, color: color),
            )
          ],
        ),
      ),
    );
  }
}

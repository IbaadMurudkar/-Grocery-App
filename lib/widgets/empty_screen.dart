import 'package:ecommerce_app/inner_screens/feeds_screen.dart';
import 'package:flutter/material.dart';
import '../services/utils.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen(
      {Key? key,
      required this.imagePath,
      required this.title,
      required this.subtitle,
      required this.buttontext})
      : super(key: key);

  final String imagePath;
  final String title;
  final String subtitle;
  final String buttontext;

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final Color color = Utils(context).color;
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(
          top: 40,
          left: 8,
          right: 8,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: double.infinity,
              height: size.height * 0.4,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Whoops!',
              style: TextStyle(
                  fontSize: 40, color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 25,
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.cyan)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const FeedsScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    buttontext,
                    style: TextStyle(
                        fontSize: 30,
                        color: color,
                        fontWeight: FontWeight.bold),
                  ),
                ))
          ],
        ),
      )),
    );
  }
}

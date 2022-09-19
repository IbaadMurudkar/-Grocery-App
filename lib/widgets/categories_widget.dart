import 'package:ecommerce_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../inner_screens/category_screen.dart';
import '../providers/dark_theme_provider.dart';

class CategoriesWidget extends StatelessWidget {
 // static const routeName = "/CategoriesScreen";
  const CategoriesWidget(
      {Key? key,
      required this.passedColor,
      required this.catText,
      required this.imgPath})
      : super(key: key);

  final String catText, imgPath;
  final Color passedColor;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, CategoriesScreen.routeName, arguments: catText);
        print('iiiiiiiiiiiii');
      },
      child: Container(
        decoration: BoxDecoration(
            color: passedColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: passedColor.withOpacity(0.7), width: 2)),
        child: Column(
          children: [
            Container(
              height: screenWidth * 0.3,
              width: screenWidth * 0.3,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(imgPath), fit: BoxFit.fill)),
            ),
            TextWidget(
              text: catText,
              color: color,
              textSize: 20,
              isTitle: true,
            )
          ],
        ),
      ),
    );
  }
}

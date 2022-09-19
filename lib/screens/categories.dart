import 'package:ecommerce_app/widgets/categories_widget.dart';
import 'package:flutter/material.dart';
import '../services/utils.dart';

class Categories extends StatelessWidget {
  static const routeName = "/CategoriesScreen";
  Categories({Key? key}) : super(key: key);

  List<Color> gridColors = [
    const Color(0xff53B175),
    const Color(0xffF8A44C),
    const Color(0xffF7A593),
    const Color(0xffD3B0E0),
    const Color(0xffFDE598),
    const Color(0xffB7DFF5),
  ];

  List<Map<String, dynamic>> catInfo = [
    {
      'imgPath': 'assets/cat/fruits.png',
      'catText': 'Fruits',
    },
    {
      'imgPath': 'assets/cat/veg.png',
      'catText': 'Vegetables',
    },
    {
      'imgPath': 'assets/cat/Spinach.png',
      'catText': 'Herbs',
    },
    {
      'imgPath': 'assets/cat/nuts.png',
      'catText': 'Nuts',
    },
    {
      'imgPath': 'assets/cat/spices.png',
      'catText': 'Spices',
    },
    {
      'imgPath': 'assets/cat/grains.png',
      'catText': 'Grains',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final utils = Utils(context);
    Color color = utils.color;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Category Screen'),
          backgroundColor: Colors.orange[400],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 240 / 250,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: List.generate(6, (index) {
              return CategoriesWidget(
                catText: catInfo[index]['catText'],
                imgPath: catInfo[index]['imgPath'],
                passedColor: gridColors[index],
              );
            }),
          ),
        ));
  }
}

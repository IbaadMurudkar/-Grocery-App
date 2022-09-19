import 'package:card_swiper/card_swiper.dart';
import 'package:ecommerce_app/inner_screens/feeds_screen.dart';
import 'package:ecommerce_app/providers/dark_theme_provider.dart';
import 'package:ecommerce_app/services/utils.dart';
import 'package:ecommerce_app/widgets/feed_item.dart';
import 'package:ecommerce_app/widgets/text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../consts/const..dart';
import '../inner_screens/on_sale_screen.dart';
import '../models/products_model.dart';
import '../providers/products_provider.dart';
import '../widgets/on_sale_widget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> offerImages = [
    'assets/offers/Offer1.jpg',
    'assets/offers/Offer2.jpg',
    'assets/offers/Offer3.jpg',
    'assets/offers/Offer4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    final themeState = Provider.of<DarkThemeProvider>(context);
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productProvider.getProducts;
    List<ProductModel> productsOnSale = productProvider.getOnSaleProducts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        backgroundColor: Colors.orange[400],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.25,
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Image.asset(
                    offerImages[index],
                    fit: BoxFit.fill,
                  );
                },
                itemCount: offerImages.length,
                autoplay: true,
                pagination:
                    const SwiperPagination(alignment: Alignment.bottomCenter),
                control: const SwiperControl(),
              ),
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const OnSaleScreen()));
                },
                child: TextWidget(
                    text: 'ViewAll', color: Colors.blue, textSize: 20)),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 7, bottom: 40),
                  child: RotatedBox(
                      quarterTurns: -1,
                      child: Row(
                        children: [
                          TextWidget(
                            text: 'ON SALE',
                            color: Colors.red,
                            textSize: 22,
                            isTitle: true,
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            IconlyLight.discount,
                            color: Colors.red,
                          ),
                        ],
                      )),
                ),
                Flexible(
                  child: SizedBox(
                    height: size.height * 0.24,
                    child: ListView.builder(
                      itemCount: productsOnSale.length < 10 ? productsOnSale.length : 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return ChangeNotifierProvider.value(
                            value: productsOnSale[index],
                            child: const OnSaleWidget());
                      },
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: 'Our Products',
                  color: color,
                  textSize: 22,
                  isTitle: true,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const FeedsScreen()));
                    },
                    child: TextWidget(
                      text: 'Browse All',
                      color: Colors.blue,
                      textSize: 20,
                    )),
              ],
            ),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: size.width / (size.height * 0.58),
              children: List.generate(
                  allProducts.length < 4 ? allProducts.length : 4, (index) {
                return ChangeNotifierProvider.value(
                    value: allProducts[index],
                    child:  const FeedsWidget());
              }),
            )
          ],
        ),
      ),
    );
  }
}

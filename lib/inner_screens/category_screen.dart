import 'package:ecommerce_app/models/products_model.dart';
import 'package:ecommerce_app/providers/products_provider.dart';
import 'package:ecommerce_app/widgets/empty_product_widget.dart';
import 'package:ecommerce_app/widgets/feed_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/utils.dart';
import '../widgets/text_widget.dart';

class CategoriesScreen extends StatefulWidget {
  // static const routeName = "/CategoryScreenState";
  static const routeName = "/CategoriesScreen";

  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  TextEditingController searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();
  List<ProductModel> listProductSearch = [];

  @override
  void dispose() {
    searchTextController.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    final catName = ModalRoute.of(context)!.settings.arguments as String;
    List<ProductModel> productsByCategory =
        productProvider.findByCategory(catName);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange[400],
          title: TextWidget(
            text: catName,
            color: Colors.white,
            textSize: 22,
            isTitle: true,
          )),
      body: productsByCategory.isEmpty
          ? const EmptyProductWidget(
              text: "No Products belong to this Category!")
          : SingleChildScrollView(
              child: Column(

                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: kBottomNavigationBarHeight,
                      child: TextField(
                        controller: searchTextController,
                        focusNode: _searchTextFocusNode,
                        onChanged: (value) {
                          setState(() {
                            listProductSearch =
                                productProvider.searchQuery(value);
                          });
                        },
                        decoration: InputDecoration(
                            hintText: "What's on your Mind?",
                            prefixIcon: const Icon(Icons.search),
                            suffix: IconButton(
                              onPressed: () {
                                searchTextController.clear();
                                _searchTextFocusNode.unfocus();
                              },
                              icon: Icon(
                                Icons.close,
                                color: _searchTextFocusNode.hasFocus
                                    ? Colors.red
                                    : color,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1.5, color: Colors.black),
                                borderRadius: BorderRadius.circular(30)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1.5, color: Colors.black),
                                borderRadius: BorderRadius.circular(30))),
                      ),
                    ),
                  ),
                  searchTextController.text.isNotEmpty &&
                          listProductSearch.isEmpty
                      ? const EmptyProductWidget(
                          text: 'No Product found, Please try Another Keyword')
                      : GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: size.width / (size.height * 0.58),
                          children: List.generate(
                              searchTextController.text.isNotEmpty
                                  ? listProductSearch.length
                                  : productsByCategory.length, (index) {
                            return ChangeNotifierProvider.value(
                                value: searchTextController.text.isNotEmpty
                                    ? listProductSearch[index]
                                    : productsByCategory[index],
                                child: const FeedsWidget());
                          }),
                        )
                ],
              ),
            ),
    );
  }
}

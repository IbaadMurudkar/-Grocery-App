import 'package:ecommerce_app/models/products_model.dart';
import 'package:ecommerce_app/providers/products_provider.dart';
import 'package:ecommerce_app/widgets/feed_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/utils.dart';
import '../widgets/empty_product_widget.dart';
import '../widgets/text_widget.dart';

class FeedsScreen extends StatefulWidget {
  static const routeName = "/FeedsScreen";

  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  TextEditingController searchTextController = TextEditingController();
  final FocusNode _searchTextFocusNode = FocusNode();

  @override
  void dispose() {
    searchTextController.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  List<ProductModel> listProductSearch = [];

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).color;
    Size size = Utils(context).getScreenSize;
    final productProvider = Provider.of<ProductsProvider>(context);
    List<ProductModel> allProducts = productProvider.getProducts;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.orange[400],
          title: TextWidget(
            text: ' All Products',
            color: Colors.white,
            textSize: 22,
            isTitle: true,
          )),
      body: SingleChildScrollView(
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
                      listProductSearch = productProvider.searchQuery(value);
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
                          color:
                              _searchTextFocusNode.hasFocus ? Colors.red : color,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(30)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(30))),
                ),
              ),
            ),
            searchTextController.text.isNotEmpty && listProductSearch.isEmpty
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
                            : allProducts.length, (index) {
                      return ChangeNotifierProvider.value(
                          value: searchTextController.text.isNotEmpty
                              ? listProductSearch[index]
                              : allProducts[index],
                          child: const FeedsWidget());
                    }),
                  )
          ],
        ),
      ),
    );
  }
}

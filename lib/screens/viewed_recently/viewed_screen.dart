import 'package:ecommerce_app/screens/viewed_recently/viewed_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../../providers/viewed_provider.dart';
import '../../services/global_methods.dart';
import '../../widgets/empty_screen.dart';
import '../../widgets/text_widget.dart';

class ViewedScreen extends StatelessWidget {
  const ViewedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewedProvider = Provider.of<ViewedProvider>(context);
    final viewedItemsList =
        viewedProvider.getViewedItems.values.toList().reversed.toList();
    if (viewedItemsList.isEmpty) {
      return const EmptyScreen(
        title: 'Your History is Empty',
        imagePath: 'assets/images/wishlist.png',
        subtitle: 'Explore more and Shortlist some items',
        buttontext: 'Add a wish',
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 18),
              child: IconButton(
                  onPressed: () {
                    GlobalMethods.warningDialog(
                        title: 'Delete History?',
                        subtitle: 'Are you Sure?',
                        fct: () {},
                        context: context);
                  },
                  icon: const Icon(
                    IconlyBroken.delete,
                    color: Colors.white,
                    size: 30,
                  )),
            )
          ],
          title: TextWidget(
            text: 'History',
            color: Colors.white,
            textSize: 22,
            isTitle: true,
          ),
          backgroundColor: Colors.orange[400],
        ),
        body: ListView.builder(
            itemCount: viewedItemsList.length,
            itemBuilder: (context, index) {
              return ChangeNotifierProvider.value(
                  value: viewedItemsList[index], child: const ViewedWidget());
            }),
      );
    }
  }
}

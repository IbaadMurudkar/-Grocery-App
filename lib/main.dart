import 'package:ecommerce_app/consts/theme_data.dart';
import 'package:ecommerce_app/fetch_screen.dart';
import 'package:ecommerce_app/inner_screens/on_sale_screen.dart';
import 'package:ecommerce_app/inner_screens/product_detail.dart';
import 'package:ecommerce_app/providers/cart_provider.dart';
import 'package:ecommerce_app/providers/dark_theme_provider.dart';
import 'package:ecommerce_app/providers/orderProvider.dart';
import 'package:ecommerce_app/providers/products_provider.dart';
import 'package:ecommerce_app/providers/viewed_provider.dart';
import 'package:ecommerce_app/providers/wishlist_provider.dart';
import 'package:ecommerce_app/screens/auth/login.dart';
import 'package:ecommerce_app/screens/auth/register.dart';
import 'package:ecommerce_app/screens/btm_bar.dart';
import 'package:ecommerce_app/screens/orders/orders_screen.dart';
import 'package:ecommerce_app/screens/viewed_recently/viewed_screen.dart';
import 'package:ecommerce_app/screens/wishlist/wishlist_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'inner_screens/category_screen.dart';
import 'inner_screens/feeds_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();

  void getCurrentAppTheme() async {
    themeChangeProvider.setDarkTheme =
        await themeChangeProvider.darkThemePrefs.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> firebaseInitialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebaseInitialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }else if(snapshot.hasError){
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: Text("An Error Occurred"),
                ),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) {
                return themeChangeProvider;
              }),
              ChangeNotifierProvider(create: (_) => ProductsProvider()),
              ChangeNotifierProvider(create: (_) => CartProvider()),
              ChangeNotifierProvider(create: (_) => WishlistProvider()),
              ChangeNotifierProvider(create: (_) => ViewedProvider()),
              ChangeNotifierProvider(create: (_) => OrdersProvider())
            ],
            child: Consumer<DarkThemeProvider>(
                builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Flutter Demo',
                theme: Styles.themeData(themeProvider.getDarkTheme, context),
                home: const FetchScreen(),
                routes: {
                  OnSaleScreen.routeName: (ctx) => const OnSaleScreen(),
                  FeedsScreen.routeName: (ctx) => const FeedsScreen(),
                  ProductDetailScreen.routeName: (ctx) =>
                      const ProductDetailScreen(),
                  'WishlistScreen': (ctx) => const WishlistScreen(),
                  'OrdersScreen': (ctx) => const OrdersScreen(),
                  'ViewedScreen': (ctx) => const ViewedScreen(),
                  'RegisterScreen': (ctx) => const RegisterScreen(),
                  'LoginScreen': (ctx) => const LoginScreen(),
                  // 'ForgetPasswordScreen': (ctx) =>
                  // const ForgetPasswordScreen(),
                  CategoriesScreen.routeName: (ctx) =>const CategoriesScreen(),
                },
              );
            }),
          );
        });
  }
}

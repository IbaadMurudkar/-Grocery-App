import 'package:badges/badges.dart';
import 'package:ecommerce_app/screens/cart/cart_screen.dart';
import 'package:ecommerce_app/screens/categories.dart';
import 'package:ecommerce_app/screens/home_screen.dart';
import 'package:ecommerce_app/screens/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/dark_theme_provider.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({Key? key}) : super(key: key);

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _pages = [
    {'page': HomeScreen(), 'title': 'Home Screen'},
    {'page': Categories(), 'title': 'Category Screen'},
    {'page': CartsScreen(), 'title': 'Cart Screen'},
    {'page': UserScreen(), 'title': 'User Screen'},
  ];

  void _selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);

    return Scaffold(
      // appBar: AppBar(
      //     backgroundColor: Colors.orange[400],
      //     title: Text(_pages[_selectedIndex]['title'])),
      body: _pages[_selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        fixedColor: themeState.getDarkTheme ? Colors.white : Colors.black87,
        onTap: _selectedPage,
        currentIndex: _selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 0 ? IconlyBold.home : IconlyLight.home,
                color: Colors.orange,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 1
                    ? IconlyBold.category
                    : IconlyLight.category,
                color: Colors.orange,
              ),
              label: 'Category'),
          BottomNavigationBarItem(
              icon: Consumer<CartProvider>(builder: (_, myCart, child) {
                return Badge(
                  toAnimate: true,
                  shape: BadgeShape.circle,
                  badgeColor: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                  badgeContent: Text(myCart.getCartItems.length.toString(),
                      style: const TextStyle(color: Colors.white)),
                  child: Icon(
                    _selectedIndex == 2 ? IconlyBold.buy : IconlyLight.buy,
                    color: Colors.orange,
                  ),
                );
              }),
              label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == 3 ? IconlyBold.user2 : IconlyLight.user2,
                color: Colors.orange,
              ),
              label: 'User'),
        ],
      ),
    );
  }
}

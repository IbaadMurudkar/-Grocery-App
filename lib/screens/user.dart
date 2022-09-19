import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/firebase_const.dart';
import 'package:ecommerce_app/providers/wishlist_provider.dart';
import 'package:ecommerce_app/screens/auth/forgot_password.dart';
import 'package:ecommerce_app/screens/auth/login.dart';
import 'package:ecommerce_app/screens/orders/orders_screen.dart';
import 'package:ecommerce_app/screens/viewed_recently/viewed_screen.dart';
import 'package:ecommerce_app/screens/wishlist/wishlist_screen.dart';
import 'package:ecommerce_app/services/global_methods.dart';
import 'package:ecommerce_app/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import '../providers/dark_theme_provider.dart';
import 'loading_manager.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final TextEditingController _addressTextController = TextEditingController();

  Future<void> _showAddressDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update'),
            content: TextField(
              maxLines: 5,
              controller: _addressTextController,
              decoration: const InputDecoration(hintText: 'your address here'),
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  String _uid = user!.uid;
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(_uid)
                        .update({
                      'shipping-address': _addressTextController.text,
                    });

                    Navigator.pop(context);
                    setState(() {
                      address = _addressTextController.text;
                    });
                  } catch (err) {
                    GlobalMethods.errorDialog(
                        subtitle: err.toString(), context: context);
                  }
                },
                child: const Text('Update'),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  bool _isLoading = false;
  String? _email;
  String? _name;
  String? address;

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;

      final DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (userDoc == null) {
        return;
      } else {
        _email = userDoc.get('email');
        _name = userDoc.get('name');
        address = userDoc.get('shipping-address');
        _addressTextController.text = userDoc.get('shipping-address');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _addressTextController.dispose();
    super.dispose();
  }

  final User? user = authInstance.currentUser;

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Screen'),
        backgroundColor: Colors.orange[400],
      ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: RichText(
                      text: TextSpan(
                          text: 'Hi,  ',
                          style: const TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange),
                          children: <TextSpan>[
                        TextSpan(
                            text: _name == null ? 'user' : _name,
                            style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.w600,
                                color: color))
                      ])),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 5),
                  child: TextWidget(
                    color: color,
                    text: _email == null ? 'Email' : _email!,
                    textSize: 18,
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                _listTile(
                    color: color,
                    title: 'Address',
                    subtitle: address,
                    icon: IconlyLight.profile,
                    onPressed: () async {
                      await _showAddressDialog();
                    }),
                _listTile(
                    color: color,
                    title: 'Orders',
                    icon: IconlyLight.bag,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const OrdersScreen()));
                    }),
                _listTile(
                    color: color,
                    title: 'WishList',
                    icon: IconlyLight.heart,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const WishlistScreen()));
                    }),
                _listTile(
                    color: color,
                    title: 'Forgot Password',
                    icon: IconlyLight.unlock,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ForgotPassword()));
                    }),
                _listTile(
                    color: color,
                    title: 'Viewed',
                    icon: IconlyLight.show,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ViewedScreen()));
                    }),
                SwitchListTile(
                  title: const Text(
                    'Theme',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  secondary: Icon(themeState.getDarkTheme
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined),
                  onChanged: (bool value) {
                    setState(() {
                      themeState.setDarkTheme = value;
                    });
                  },
                  value: themeState.getDarkTheme,
                ),
                _listTile(
                  title: user == null ? 'Login' : 'Logout',
                  icon: user == null ? IconlyLight.login : IconlyLight.logout,
                  onPressed: () {
                    if (user == null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                      return;
                    }
                    GlobalMethods.warningDialog(
                        title: 'Sign out',
                        subtitle: 'Do you wanna sign out?',
                        fct: () async {
                          final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
                          wishlistProvider.clearLocalWishlist();
                          await authInstance.signOut();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        context: context);
                  },
                  color: color,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _listTile(
      {required String title,
      String? subtitle,
      required IconData icon,
      required Color color,
      required Function onPressed}) {
    return ListTile(
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      subtitle: TextWidget(
        color: color,
        text: subtitle ?? '',
        textSize: 18,
      ),
      onTap: () {
        onPressed();
      },
    );
  }
}

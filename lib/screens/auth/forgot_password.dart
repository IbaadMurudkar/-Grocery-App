import 'package:card_swiper/card_swiper.dart';
import 'package:ecommerce_app/consts/firebase_const.dart';
import '../loading_manager.dart';
import 'package:ecommerce_app/services/global_methods.dart';
import 'package:ecommerce_app/widgets/auth_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../consts/const..dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void forgotPassword() async {
    if (emailController.text.isEmpty || !emailController.text.contains('@')) {
      GlobalMethods.errorDialog(
          subtitle: 'Please Enter Valid Email', context: context);
    } else {
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance.sendPasswordResetEmail(
            email: emailController.text.toLowerCase());
        Fluttertoast.showToast(
            msg: "An Email has been send to your Email Address",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orangeAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
      ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: Stack(
          children: [
            Swiper(
              duration: 1000,
              autoplayDelay: 8000,
              itemBuilder: (BuildContext context, int index) {
                return Image.asset(
                  Const.authImagePaths[index],
                  fit: BoxFit.fill,
                );
              },
              itemCount: Const.authImagePaths.length,
              autoplay: true,
            ),
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                    child: Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter Valid Email';
                      } else {
                        return null;
                      }
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white))),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  AuthButton(
                      fct: () {
                        forgotPassword();
                      },
                      buttonText: 'Rest Now')
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

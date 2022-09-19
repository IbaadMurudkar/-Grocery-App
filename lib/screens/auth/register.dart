import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/fetch_screen.dart';
import 'package:ecommerce_app/screens/auth/forgot_password.dart';
import 'package:ecommerce_app/services/global_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../consts/const..dart';
import '../../consts/firebase_const.dart';
import '../../widgets/auth_button.dart';
import '../../widgets/text_widget.dart';
import '../loading_manager.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final fullNameController = TextEditingController();
  final addressController = TextEditingController();
  final _passFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  bool obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    _passFocusNode.dispose();
    fullNameController.dispose();
    _emailFocusNode.dispose();
    _addressFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void submitFormOnResgister() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance.createUserWithEmailAndPassword(
            email: emailController.text.toLowerCase().trim(),
            password: passController.text.trim());
        final User? user = authInstance.currentUser;
        final _uid = user!.uid;
        user.updateDisplayName(fullNameController.text);
        user.reload();
        user.updateDisplayName(fullNameController.text);
        user.reload();
        await FirebaseFirestore.instance.collection('users').doc(_uid).set({
          'id': _uid,
          'name': fullNameController.text,
          'email': emailController.text.toLowerCase(),
          'shipping-address': addressController.text,
          'userWish': [],
          'userCart': [],
          'createdAt': Timestamp.now(),
        });
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const FetchScreen()));
        print('Successfully Registered');
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
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    TextWidget(
                      text: 'Welcome',
                      color: Colors.white,
                      textSize: 30,
                      isTitle: true,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextWidget(
                      text: 'Sign up to Continue',
                      color: Colors.white,
                      textSize: 18,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: fullNameController,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_emailFocusNode),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This Field is Empty';
                                } else {
                                  return null;
                                }
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: 'Full Name',
                                  hintStyle: TextStyle(color: Colors.white),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                            ),
                            TextFormField(
                              controller: emailController,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => FocusScope.of(context)
                                  .requestFocus(_passFocusNode),
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
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            TextFormField(
                              obscureText: obscureText,
                              controller: passController,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty || value.length > 7) {
                                  return 'Please enter Valid Password';
                                } else {
                                  return null;
                                }
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        obscureText = !obscureText;
                                      });
                                    },
                                    child: Icon(
                                      obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.white,
                                    ),
                                  ),
                                  hintText: 'Password',
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  enabledBorder: const UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                            ),
                            TextFormField(
                              focusNode: _addressFocusNode,
                              controller: addressController,
                              textInputAction: TextInputAction.go,
                              onEditingComplete: submitFormOnResgister,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This Field is Empty';
                                } else {
                                  return null;
                                }
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  hintText: 'Shipping Address',
                                  hintStyle: TextStyle(color: Colors.white),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                            ),
                          ],
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ForgotPassword()));
                          },
                          child: const Text(
                            'Forgot Password?',
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    AuthButton(
                        fct: () {
                          submitFormOnResgister();
                        },
                        buttonText: 'Sign Up'),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Already a User?",
                          style: const TextStyle(fontSize: 18),
                          children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()));
                                  },
                                text: '  Sign In',
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue))
                          ]),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
    ;
  }
}

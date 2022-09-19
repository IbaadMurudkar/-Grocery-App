import 'package:card_swiper/card_swiper.dart';
import 'package:ecommerce_app/consts/const..dart';
import 'package:ecommerce_app/fetch_screen.dart';
import 'package:ecommerce_app/screens/auth/forgot_password.dart';
import 'package:ecommerce_app/screens/auth/register.dart';
import 'package:ecommerce_app/screens/btm_bar.dart';
import 'package:ecommerce_app/widgets/auth_button.dart';
import 'package:ecommerce_app/widgets/google_button.dart';
import 'package:ecommerce_app/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../consts/firebase_const.dart';
import '../../services/global_methods.dart';
import '../loading_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final _passFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  bool obscureText = true;

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    _passFocusNode.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void submitFormOnLogin() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      try {
        await authInstance.signInWithEmailAndPassword(
            email: emailController.text.toLowerCase().trim(),
            password: passController.text.trim());
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const BottomBarScreen()));
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
                      height: 120,
                    ),
                    TextWidget(
                      text: 'Welcome Back',
                      color: Colors.white,
                      textSize: 30,
                      isTitle: true,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextWidget(
                      text: 'Sign in to Continue',
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
                              textInputAction: TextInputAction.go,
                              onEditingComplete: submitFormOnLogin,
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
                          submitFormOnLogin();
                        },
                        buttonText: 'Login'),
                    const SizedBox(
                      height: 10,
                    ),
                    GoogleButton(),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Expanded(
                            child: Divider(thickness: 2, color: Colors.white)),
                        const SizedBox(
                          width: 5,
                        ),
                        TextWidget(
                            text: 'OR', color: Colors.white, textSize: 18),
                        const SizedBox(
                          width: 5,
                        ),
                        const Expanded(
                            child: Divider(thickness: 2, color: Colors.white)),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    AuthButton(
                      fct: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const FetchScreen()));
                      },
                      buttonText: 'Continue as a Guest',
                      primary: Colors.black,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                          text: "Don't have an Account?",
                          style: const TextStyle(fontSize: 18),
                          children: [
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const RegisterScreen()));
                                  },
                                text: '  Sign Up',
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
  }
}

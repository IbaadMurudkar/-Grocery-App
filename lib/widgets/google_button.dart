import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/consts/firebase_const.dart';
import 'package:ecommerce_app/fetch_screen.dart';
import 'package:ecommerce_app/screens/btm_bar.dart';
import 'package:ecommerce_app/widgets/text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/global_methods.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({Key? key}) : super(key: key);

  Future<void> _googleSignIn(context) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResult = await authInstance.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken),
          );
          if (authResult.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(authResult.user!.uid)
                .set({
              'id': authResult.user!.uid,
              'name': authResult.user!.displayName,
              'email': authResult.user!.email,
              'shipping-address': '',
              'userWish': [],
              'userCart': [],
              'createdAt': Timestamp.now(),
            });
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const FetchScreen(),
            ),
          );
        } on FirebaseException catch (error) {
          GlobalMethods.errorDialog(
              subtitle: '${error.message}', context: context);
        } catch (error) {
          GlobalMethods.errorDialog(subtitle: '$error', context: context);
        } finally {}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blue,
      child: InkWell(
        onTap: () {
          _googleSignIn(context);
        },
        child: Row(
          children: [
            Container(
                color: Colors.white,
                child: Image.asset(
                  'assets/images/google.png',
                  width: 40,
                )),
            const SizedBox(
              width: 10,
            ),
            TextWidget(
                text: 'Sign In with google', color: Colors.white, textSize: 18),
          ],
        ),
      ),
    );
  }
}

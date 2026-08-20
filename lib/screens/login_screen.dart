import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:bbusrd104/config/app_colors.dart';
import 'package:bbusrd104/screens/main_screen.dart';
import 'package:bbusrd104/screens/signup_screen.dart';
import 'package:bbusrd104/screens/reset_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPassword = true;
  final keyForm = GlobalKey<FormState>();
  final textemail = TextEditingController();
  final txtpwd = TextEditingController();

  @override
  void dispose() {
    textemail.dispose();
    txtpwd.dispose();
    super.dispose();
  }

  void togglePassword() {
    setState(() {
      isPassword = !isPassword;
    });
  }

  Future<void> signIn() async {
    try {
      EasyLoading.show(status: 'Signing in...');
      final sp = await SharedPreferences.getInstance();

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: textemail.text.trim(), password: txtpwd.text.trim());

      User? user = userCredential.user;
      if (user != null) {
        await user.reload();
        user = FirebaseAuth.instance.currentUser;

        if (user!.emailVerified) {
          // Read user profile from Firestore
          DocumentSnapshot userData = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          // Save user profile with app
          if (userData.exists && userData.data() != null) {
            Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
            await sp.setString('FULLNAME', data['fullname'] ?? '');
            await sp.setString("EMAIL", data['email'] ?? '');
            await sp.setString('UID', user.uid);
          }

          EasyLoading.dismiss();
          EasyLoading.showSuccess('Login successful!');

          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MainScreen()),
            (route) => false,
          );
        } else {
          // ផ្ញើ Verification Email ថ្មីទៅកាន់ Gmail របស់ User ភ្លាមៗ
          await user.sendEmailVerification();
          await FirebaseAuth.instance.signOut();
          
          EasyLoading.dismiss();
          EasyLoading.instance.toastPosition = EasyLoadingToastPosition.top;
          EasyLoading.showToast(
            'Email is not verified! A new verification link has been sent to your Gmail.',
            duration: const Duration(seconds: 4),
            toastPosition: EasyLoadingToastPosition.top,
          );
        }
      }
    } on FirebaseAuthException catch (ex) {
      EasyLoading.dismiss();
      EasyLoading.instance.toastPosition = EasyLoadingToastPosition.top;
      EasyLoading.showToast(
        ex.message ?? 'Authentication error',
        toastPosition: EasyLoadingToastPosition.top,
      );
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.instance.toastPosition = EasyLoadingToastPosition.top;
      EasyLoading.showToast(
        'An error occurred!',
        toastPosition: EasyLoadingToastPosition.top,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login User'),
        centerTitle: true,
      ),
      body: Form(
        key: keyForm,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Image.asset(
                'assets/images/person.png',
                height: 100,
                width: 100,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.account_circle,
                  size: 100,
                  color: AppColors.bgColor,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextFormField(
                controller: textemail,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  final emailRegExp = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );

                  if (value == null ||
                      value.isEmpty ||
                      !emailRegExp.hasMatch(value.trim())) {
                    return 'Your email is invalid';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              child: TextFormField(
                controller: txtpwd,
                obscureText: isPassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Required password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: GestureDetector(
                      onTap: togglePassword,
                      child: isPassword
                          ? const Icon(Icons.visibility_rounded)
                          : const Icon(Icons.visibility_off_rounded),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 52,
              margin: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bgColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  if (keyForm.currentState!.validate()) {
                    signIn();
                  }
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResetPasswordScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: AppColors.bgColor),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: AppColors.bgColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
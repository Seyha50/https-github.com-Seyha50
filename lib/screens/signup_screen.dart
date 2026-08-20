import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:bbusrd104/config/app_colors.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final fullName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  // Visibility states
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  @override
  void dispose() {
    fullName.dispose();
    email.dispose();
    password.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  // Firebase Sign Up Action
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      EasyLoading.show(status: 'Creating Account...');

      // 1. Sign Up User with Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text.trim(), password: password.text.trim());

      User? user = userCredential.user;

      if (user != null) {
        // 2. Send Email Verification to Gmail
        await user.sendEmailVerification();

        // 3. Save user profile to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set({
          'userId': user.uid,
          'fullname': fullName.text.trim(),
          'email': email.text.trim(),
          'isActive': true,
          'createdAt': DateTime.now(),
        });

        // 4. Sign Out current session so user must verify email before logging in
        await FirebaseAuth.instance.signOut();

        EasyLoading.dismiss();

        // Show Success Toast at TOP
        EasyLoading.instance.toastPosition = EasyLoadingToastPosition.top;
        EasyLoading.showToast(
          'Registered successfully! Please check your Gmail to verify.',
          duration: const Duration(seconds: 4),
          toastPosition: EasyLoadingToastPosition.top,
        );

        if (mounted) {
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            Navigator.pop(context); // Return to LoginScreen
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.instance.toastPosition = EasyLoadingToastPosition.top;
      EasyLoading.showToast(
        e.message ?? 'Registration failed',
        toastPosition: EasyLoadingToastPosition.top,
      );
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.instance.toastPosition = EasyLoadingToastPosition.top;
      EasyLoading.showToast(
        'An unexpected error occurred',
        toastPosition: EasyLoadingToastPosition.top,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),

                // Avatar Icon Header
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.bgColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 45,
                      backgroundColor: AppColors.bgColor,
                      child: Icon(
                        Icons.person_add_rounded,
                        size: 50,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                const Text(
                  'Join Us Today!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.bgColor,
                  ),
                ),
                const SizedBox(height: 30),

                // Full Name Field
                TextFormField(
                  controller: fullName,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 18),

                // Email Field
                TextFormField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    final emailRegExp = RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    );
                    if (value == null ||
                        value.trim().isEmpty ||
                        !emailRegExp.hasMatch(value.trim())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email Address',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                const SizedBox(height: 18),

                // Password Field
                TextFormField(
                  controller: password,
                  obscureText: _isPasswordHidden,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Confirm Password Field
                TextFormField(
                  controller: confirmPassword,
                  obscureText: _isConfirmPasswordHidden,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != password.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock_reset_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordHidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordHidden =
                              !_isConfirmPasswordHidden;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Submit Button
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.bgColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    onPressed: _signUp,
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Already Have an Account Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Log In',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.bgColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
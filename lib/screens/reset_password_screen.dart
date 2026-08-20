import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:bbusrd104/config/app_colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  // Variable សម្រាប់កំណត់បង្ហាញ Success Screen
  bool _isSubmitted = false;
  // Variable សម្រាប់គ្រប់គ្រងការបង្ហាញ ឬលាក់ Success Status Box ពណ៌ខៀវ
  bool _showCard = true;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  // Firebase Send Password Reset Email
  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      EasyLoading.show(status: 'Sending reset link...');

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      EasyLoading.dismiss();

      // ប្ដូរ State ទៅជា true ដើម្បីបង្ហាញ Success View
      setState(() {
        _isSubmitted = true;
        _showCard = true; // ប្រាកដថា Card ត្រូវបង្ហាញដំបូង
      });
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      EasyLoading.instance.toastPosition = EasyLoadingToastPosition.top;
      EasyLoading.showToast(
        e.message ?? 'Failed to send reset email',
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.bgColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reset Password',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: _isSubmitted ? _buildSuccessView() : _buildFormView(),
        ),
      ),
    );
  }

  // 1. Form UI
  Widget _buildFormView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 10),

          // Lock Icon Header
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                color: AppColors.bgColor,
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '***',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  Container(
                    width: 35,
                    height: 3,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 35),

          // Description Text
          const Text(
            'To reset your password, start by entering the email address you signed up with.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 25),

          // Email TextFormField
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              final emailRegExp = RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              );
              if (value == null ||
                  value.trim().isEmpty ||
                  !emailRegExp.hasMatch(value.trim())) {
                return 'Your email is invalid!';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: const TextStyle(color: Colors.red),
              hintText: 'Email',
              prefixIcon: const Icon(Icons.email, color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: AppColors.bgColor,
                  width: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),

          // Continue Button
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.bgColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: _resetPassword,
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 2. Success UI
  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),

        // Success Checkmark Circle
        Center(
          child: Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              color: AppColors.bgColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 60,
            ),
          ),
        ),
        const SizedBox(height: 40),

        // Success Description
        const Text(
          'Password reset confirmation email was sent to your email.',
          style: TextStyle(
            fontSize: 15,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 30),

        // Success Status Box - បង្ហាញលុះត្រាតែ _showCard == true
        if (_showCard)
          GestureDetector(
            onTap: () {
              setState(() {
                _showCard = false; // ចុចពីលើដើម្បីលាក់ Box ពណ៌ខៀវ
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 32,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'The link already sent to your email.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
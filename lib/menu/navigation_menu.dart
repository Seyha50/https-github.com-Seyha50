import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:bbusrd104/config/app_colors.dart';
import 'package:bbusrd104/menu/about_us.dart';
import 'package:bbusrd104/menu/contact_us.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  String? fullname;
  String? email;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      fullname = sp.getString("FULLNAME");
      email = sp.getString("EMAIL");
    });
  }

  Future<void> _signOut() async {
    EasyLoading.show();
    await Future.delayed(const Duration(seconds: 1));
    final sp = await SharedPreferences.getInstance();
    await sp.clear();
    await FirebaseAuth.instance.signOut();
    EasyLoading.dismiss();
  }

  Future<void> _confirmSignOut() async {
    Navigator.pop(context);
    final isSignOut = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContex) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(dialogContex).pop(true),
              child: const Text('YES')),
        ],
      ),
    );
    if (isSignOut == true) {
      _signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(fullname ?? 'Guest User'),
            accountEmail: Text(email ?? ''),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/person.png',
                  fit: BoxFit.cover,
                  width: 90,
                  height: 90,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person, size: 50);
                  },
                ),
              ),
            ),
            decoration: BoxDecoration(color: AppColors.bgColor),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUs()),
              );
            },
            leading: const Icon(Icons.account_circle),
            title: const Text('About Us'),
            // trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactUs()),
              );
            },
            leading: const Icon(Icons.phone_in_talk),
            title: const Text('Contact Us'),
          ),
          const Divider(),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.notifications),
            title: const Text('Promotions'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.question_mark),
            title: const Text('FAQs'),
          ),
          const Divider(),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.message),
            title: const Text('Feedback'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.list_alt),
            title: const Text('Terms of Use'),
          ),
          const Divider(),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.person),
            title: const Text('My Profile'),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.password),
            title: const Text('Change Password'),
          ),
          ListTile(
            onTap: () => _confirmSignOut(),
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

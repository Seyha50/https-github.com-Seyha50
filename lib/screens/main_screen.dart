import 'package:flutter/material.dart';
import 'package:bbusrd104/config/app_colors.dart';
import 'package:bbusrd104/menu/Popular_items.dart';
import 'package:bbusrd104/menu/favorite_items.dart';
import 'package:bbusrd104/menu/navigation_menu.dart';
import 'package:bbusrd104/screens/cards/categories/category_screen.dart';
import 'package:bbusrd104/screens/cards/contact_screen.dart';
import 'package:bbusrd104/screens/cards/group_screen.dart';
import 'package:bbusrd104/screens/cards/help_screen.dart';
import 'package:bbusrd104/screens/cards/product_screen.dart';
import 'package:bbusrd104/screens/cards/setting_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? fullname;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      fullname = sp.getString("FULLNAME");
    });
  }

  String greetingMessage() {
    int hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    } else if (hour < 18) {
      return 'Good Afternoon!';
    } else {
      return 'Good Evening!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BBU Store'),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.qr_code)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
          PopupMenuButton<int>(
            itemBuilder: (context) => <PopupMenuEntry<int>>[
              const PopupMenuItem(
                value: 1,
                child: ListTile(
                  leading: Icon(Icons.add_shopping_cart),
                  title: Text('My Orders'),
                ),
              ),
              const PopupMenuItem(
                value: 2,
                child: ListTile(
                  leading: Icon(Icons.notifications),
                  title: Text('Popular Items'),
                ),
              ),
              const PopupMenuItem(
                value: 3,
                child: ListTile(
                  leading: Icon(Icons.favorite, color: AppColors.yellow),
                  title: Text('Favorite Items'),
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 1:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProductScreen()),
                  );
                  break;
                case 2:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PopularItems()),
                  );
                  break;
                case 3:
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FavoriteItems()),
                  );
                  break;
              }
            },
          ),
        ],
      ),
      drawer: const NavigationMenu(),
      body: Container(
        color: AppColors.bgmain,
        child: Stack(
          children: [
            Container(
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.bgColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
            ),
            ListView(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              children: [
                SizedBox(
                  height: 142,
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          child: Text(
                            greetingMessage(),
                            style: const TextStyle(
                              color: AppColors.bgColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // 2. Full Name Text (Below Greeting)
                        Container(
                          margin: const EdgeInsets.fromLTRB(10, 36, 10, 10),
                          child: Text(
                            fullname ?? 'Guest',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),

                        // 3. Action Buttons (Bottom-Left via Positioned)
                        Positioned(
                          left: 10,
                          bottom: 10,
                          child: Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.bgColor,
                                  minimumSize: const Size(100, 32),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'MY ORDERS',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(100, 32),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Text(
                                  'TOP NEWS',
                                  style: TextStyle(
                                    color: AppColors.bgColor,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 4. Profile Picture Avatar (Top-Right via Positioned)
                        const Positioned(
                          right: 10,
                          top: 10,
                          child: CircleAvatar(
                            radius: 32,
                            backgroundColor: AppColors.bgColor,
                            backgroundImage:
                                AssetImage('assets/images/person.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Grid Menu Section
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    cardBox('Contacts', Icons.person),
                    cardBox('Groups', Icons.people),
                    cardBox('Products', Icons.shopping_cart),
                    cardBox('Categories', Icons.playlist_add_check),
                    cardBox('Help', Icons.help_outline),
                    cardBox('Settings', Icons.settings),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget cardBox(String title, IconData icon) {
    return Card(
      child: InkWell(
        onTap: () {
          Widget targetScreen;
          switch (title) {
            case 'Contacts':
              targetScreen = const ContactScreen();
              break;
            case 'Products':
              targetScreen = const ProductScreen();
              break;
            case 'Groups':
              targetScreen = const GroupScreen();
              break;
            case 'Categories':
              targetScreen = const CategoryScreen();
              break;
            case 'Help':
              targetScreen = const HelpScreen();
              break;
            case 'Settings':
              targetScreen = const SettingScreen();
              break;
            default:
              return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => targetScreen),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.bgColor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                icon,
                size: 50,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: AppColors.bgColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
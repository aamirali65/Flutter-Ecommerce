import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/pages/login.dart';
import 'package:ecommerce/widgets/customText.dart';
import 'package:ecommerce/widgets/drawer_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:badges/badges.dart' as badges;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String? userEmail;
  String? userName;
  String? profileImageUrl; // To store user profile image URL
  Future<void> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('user_email');
    if (userEmail != null) {
      FirebaseFirestore.instance.collection('users')
          .where('email', isEqualTo: userEmail)
          .get()
          .then((QuerySnapshot querySnapshot) {
        if (querySnapshot.size > 0) {
          setState(() {
            userName = querySnapshot.docs[0]['username'];
            this.userEmail = userEmail;
            profileImageUrl = querySnapshot.docs[0]['profileImageUrl'];
          });
        }
      })
          .catchError((error) {
        print("Error getting user data: $error");
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserEmail();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.white
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: profileImageUrl != null
                          ? NetworkImage(profileImageUrl!) // Use Google profile image if available
                          : const AssetImage('images/profile.jpg'), // Use default image otherwise
                    ),
                    currentAccountPictureSize: const Size(60, 60),
                    accountName: MyText(userName ?? '', Colors.black, 22),
                    accountEmail: MyText(userEmail ?? '', Colors.black, 15),
                  ),
                  const SizedBox(height: 20),
                  drawerList('History', Icons.history, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ));
                  }),
                  drawerList('News', Icons.stacked_line_chart, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ));
                  }),
                  drawerList('FeedBack', Icons.feedback, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ));
                  }),
                  drawerList('FAQs', Icons.question_mark, () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ));
                  }),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: drawerList('Log out', Icons.logout_outlined, () {
                  auth.signOut().then((value) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  }).onError((error, stackTrace) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.toString())));
                  });
                })),
          ],
        ),
      ),
      appBar: AppBar(
        shadowColor: Colors.black,
        elevation: 10,
        title: MyText('Scissors Doctor', Colors.black, 20),
        actions: <Widget>[

          badges.Badge(
            badgeContent: MyText('3', Colors.white, 13),
            position: badges.BadgePosition.topEnd(top: -3, end: -2),
            child: IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
          ),badges.Badge(
            badgeContent: MyText('3', Colors.white, 13),
            position: badges.BadgePosition.topEnd(top: -3, end: -2),
            child: IconButton(onPressed: () {}, icon:const FaIcon(FontAwesomeIcons.solidHeart)),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      backgroundColor: const Color(0xffF2F2F2),
    );
  }
}

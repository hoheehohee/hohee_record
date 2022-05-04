import 'package:beamer/beamer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hohee_record/repo/user_service.dart';
import 'package:hohee_record/states/user_notifier.dart';
import 'package:hohee_record/widgets/expandable_fad.dart';
import 'package:provider/provider.dart';

import '../data/user_model.dart';
import '../utils/logger.dart';
import 'home/items_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _bottomSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    UserModel? userModel = context.watch<UserProvider>().userModel;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(userModel == null ? '' : userModel.address),
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Future.delayed(const Duration(seconds: 1),
                  () => {context.beamToNamed('/auth')});
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.text_justify),
          )
        ],
      ),
      body: IndexedStack(
        index: _bottomSelectedIndex,
        children: [
          ItemsPage(),
          Container(color: Colors.accents[1]),
          Container(color: Colors.accents[2]),
          Container(color: Colors.accents[3]),
        ],
      ),
      floatingActionButton: ExpandableFab(
        distance: 90,
        children: [
          MaterialButton(
            onPressed: () {
              context.beamToNamed('/input');
            },
            shape: CircleBorder(),
            height: 40,
            color: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.add),
          ),
          MaterialButton(
            onPressed: () {},
            shape: CircleBorder(),
            height: 40,
            color: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.add),
          ),
          // MaterialButton(
          //   onPressed: () {},
          //   shape: CircleBorder(),
          //   height: 24,
          //   color: Theme.of(context).colorScheme.primary,
          //   child: Icon(Icons.add),
          // ),

        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomSelectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _bottomSelectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                _bottomSelectedIndex == 0
                    ? 'assets/imgs/selected_home_1.png'
                    : 'assets/imgs/home_1.png',
              ),
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                _bottomSelectedIndex == 1
                    ? 'assets/imgs/selected_placeholder.png'
                    : 'assets/imgs/placeholder.png',
              ),
            ),
            label: '내 위치',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                _bottomSelectedIndex == 2
                    ? 'assets/imgs/selected_smartphone_10.png'
                    : 'assets/imgs/smartphone_10.png',
              ),
            ),
            label: '내 위치',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                _bottomSelectedIndex == 3
                    ? 'assets/imgs/selected_user_3.png'
                    : 'assets/imgs/user_3.png',
              ),
            ),
            label: '내 위치',
          ),
        ],
      ),
    );
  }
}

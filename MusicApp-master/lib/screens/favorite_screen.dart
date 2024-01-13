// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_app/widgets/widgets.dart';

import '../models/song_model.dart';
import '../utils/api_service.dart';
import 'screens.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  var favoriteList = [];
  List<SongModel> musicList = [];
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    fetchMusicData();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        getFavorList(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.deepPurple.shade800.withOpacity(0.8),
              Colors.deepPurple.shade200.withOpacity(0.8)
            ])),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "Favourite List",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            actions: const [
              IconButton(
                  onPressed: null,
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 25,
                  ))
            ],
          ),
          // body:
          body: customListCard(),
          bottomNavigationBar: const CustomNavBar(),
        ),
      ),
    );
  }

  void getFavorList(String uid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorite')
        .get()
        .then((QuerySnapshot querySnapshot) => {
              querySnapshot.docs.forEach((doc) {
                setState(() {
                  favoriteList.add(doc['id']);
                });
              })
            });
  }

  Future<void> fetchMusicData() async {
    final musiclist = await ApiService().getAllFetchMusicData();
    setState(() {
      musicList = musiclist;
    });
  }

  Widget customListCard() {
    List<SongModel> displayedSongs = [];
    for (int i = 0; i < favoriteList.length; i++) {
      displayedSongs.add(
          musicList.firstWhere((element) => element.id == favoriteList[i]));
    }
    return ListView.separated(
      separatorBuilder: (_, __) => const Divider(),
      padding: EdgeInsets.zero,
      itemCount: favoriteList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SongScreen(
                    song: displayedSongs,
                    currentIndex: index,
                  ),
                ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, bottom: 8, right: 8, top: 4),
                  child: SizedBox(
                    child: FadeInImage.assetNetwork(
                        height: 60,
                        width: 60,
                        placeholder: "assets/images/loading.jpg",
                        image: musicList
                            .firstWhere(
                                (element) => element.id == favoriteList[index])
                            .image
                            .toString(),
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      musicList
                          .firstWhere(
                              (element) => element.id == favoriteList[index])
                          .title
                          .toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      musicList
                          .firstWhere(
                              (element) => element.id == favoriteList[index])
                          .artist
                          .toString(),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: () {
                    setState(() {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
                          .collection('favorite')
                          .doc(favoriteList[index])
                          .delete();
                      favoriteList.remove(favoriteList[index]);
                    });
                  },
                  icon: const Icon(
                    Icons.remove_circle,
                    color: Colors.red,
                  ))
            ],
          ),
        );
      },
    );
  }
}

class _CustomNavBar extends StatefulWidget {
  const _CustomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  State<_CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<_CustomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const FavoriteScreen(),
    const FavoriteScreen(),
    const ProfileScreen()
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => _screens[index]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.deepPurple.shade800,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.white,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border_outlined),
            label: "Favotires",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outlined),
            label: "Play",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_alt_outlined),
            label: "Profile",
          ),
        ]);
  }
}

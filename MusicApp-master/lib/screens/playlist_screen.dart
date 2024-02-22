import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:music_app/widgets/widgets.dart';
import '../models/song_model.dart';
import '../models/playlist_model.dart'; // Import Playlist model
import '../utils/api_service.dart';
import 'screens.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late List<PlaylistModel> favoritePlaylists;

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    favoritePlaylists = [];
    fetchPlaylistData();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        getFavoritePlaylists(user.uid);
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
            ],
          ),
        ),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "Playlists",
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            actions: const [
              IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 25,
                ),
              )
            ],
          ),
          body: customListCard(),
          bottomNavigationBar: const CustomNavBar(),
        ),
      ),
    );
  }

  void getFavoritePlaylists(String uid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('favorite_playlists')
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        favoritePlaylists = querySnapshot.docs
            .map((doc) => PlaylistModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
      });
    });
  }

  Future<void> fetchPlaylistData() async {
    final musiclist = await ApiService().getAllFetchMusicData();
    favoritePlaylists = musiclist
        .map((playlist) => PlaylistModel(
              artist: playlist.artist,
              imageUrl: playlist.image, // Sử dụng image từ SongModel làm imageUrl cho PlaylistModel
              songs: [playlist], // Tạo danh sách bài hát chỉ chứa playlist hiện tại
            ))
        .toList();
    setState(() {});
  }

  Widget customListCard() {
    final Map<String, List<SongModel>> songsByArtist = groupSongsByArtist();
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: songsByArtist.length,
      itemBuilder: (context, index) {
        final artist = songsByArtist.keys.toList()[index];
        final songs = songsByArtist[artist]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                artist,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  leading: song.image != null
                      ? FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder_image.jpg', // Placeholder nếu hình ảnh không có sẵn
                          image: song.image!, // URL của hình ảnh từ SongModel
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.image), // Icon mặc định nếu không có hình ảnh
                  title: Text(
                    song.title ?? '', // Hiển thị tiêu đề bài hát (nếu có)
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  subtitle: Text(
                    song.album ?? '', // Hiển thị album bài hát (nếu có)
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  onTap: () {
                    // Xử lý khi người dùng nhấn vào bài hát
                      
                  },
                );
              },
            ),
            const Divider(color: Colors.white),
          ],
        );
      },
    );
  }

  Map<String, List<SongModel>> groupSongsByArtist() {
    final Map<String, List<SongModel>> result = {};
    for (final playlist in favoritePlaylists) {
      final artist = playlist.artist ?? 'Unknown'; // Sử dụng 'Unknown' nếu không có thông tin về nghệ sĩ
      if (!result.containsKey(artist)) {
        result[artist] = [];
      }
      result[artist]!.addAll(playlist.songs ?? []); // Thêm các bài hát của playlist vào danh sách bài hát theo nghệ sĩ
    }
    return result;
  }
}

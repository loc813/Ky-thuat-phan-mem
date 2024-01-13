import 'package:flutter/material.dart';
import 'package:music_app/screens/song_screen.dart';
import '../models/song_model.dart';

import '../utils/api_service.dart';
import '../widgets/navbar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<SongModel> musicList = [];

  List<SongModel> searchResults = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  void _onSearchTextChanged(String name) {
    if (name.isNotEmpty) {
      ApiService().getFetchMusicDataByName(name).then((results) {
        setState(() {
          searchResults = results;
        });
      }).catchError((error) {});
    } else {
      setState(() {
        searchResults = [];
      });
    }
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _cancelSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMusicData();
  }

  @override
  dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<SongModel> displayedSongs =
        searchResults.isNotEmpty ? searchResults : musicList;
    // print(displayedSongs);
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  onChanged: _onSearchTextChanged,
                  decoration: const InputDecoration(
                    hintText: 'Search Songs',
                    hintStyle: TextStyle(color: Colors.white70),
                  ),
                )
              : const Text('Search'),
          actions: [
            IconButton(
              icon: _isSearching
                  ? const Icon(Icons.clear)
                  : const Icon(Icons.search),
              onPressed: () {
                if (_isSearching) {
                  _cancelSearch();
                } else {
                  _startSearch();
                }
              },
            ),
          ],
        ),
        bottomNavigationBar: const CustomNavBar(),
        body: Column(
          children: [
            Expanded(
              child: SizedBox(
                  child: ListView.separated(
                separatorBuilder: (_, __) => const Divider(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SongScreen(
                                song: displayedSongs, currentIndex: index),
                          ));
                      // displayedSongs = musicList;
                    },
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  image: displayedSongs[index].image.toString(),
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayedSongs[index].title.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                displayedSongs[index].artist.toString(),
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        // new Spacer(),
                      ],
                    ),
                  );
                },
                itemCount: displayedSongs.length,
              )),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchMusicData() async {
    final musiclist = await ApiService().getAllFetchMusicData();
    setState(() {
      musicList = musiclist;
    });
  }
}

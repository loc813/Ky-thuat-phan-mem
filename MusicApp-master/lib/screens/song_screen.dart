// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/song_model.dart';
import 'package:audioplayers/audioplayers.dart';

class SongScreen extends StatefulWidget {
  SongScreen({Key? key, required this.song, required this.currentIndex})
      : super(key: key);
  final List<SongModel> song;
  late int currentIndex;

  @override
  State<SongScreen> createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  final StreamController<double> _positionStreamController =
      StreamController<double>();
  Timer? _timer;
  double minValue = 0.0;
  bool isFavorite = false;
  late int currentIndex;
// add favorite song to firestore to user collection
  void addFavoriteSong() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favorite')
        .doc(widget.song[widget.currentIndex].id)
        .set({
      'id': widget.song[widget.currentIndex].id,
    });
  }

  // remove favorite song from firestore
  void removeFavoriteSong() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('favorite')
        .doc(widget.song[widget.currentIndex].id)
        .delete();
  }

  @override
  void initState() {
    checkIsFavorite();
    super.initState();
    setAudio();

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    // listen to audio duration
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    // listen to audio position
    audioPlayer.onPositionChanged.listen((newPosition) {
      position = newPosition;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final currentPosition = await audioPlayer.getCurrentPosition();
      setState(() {});
      _positionStreamController.sink
          .add(currentPosition?.inMilliseconds.toDouble() ?? 0.0);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    checkIsFavorite();
    void playNext() {
      setState(() {
        widget.currentIndex++;
        audioPlayer
            .setSourceUrl(widget.song[widget.currentIndex].source.toString());
      });
    }

    void playPrevious() {
      checkIsFavorite();

      setState(() {
        widget.currentIndex--;
        audioPlayer
            .setSourceUrl(widget.song[widget.currentIndex].source.toString());
      });
    }

    final url = widget.song[widget.currentIndex].image.toString();
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: handleAddFavortie,
              icon: Icon(
                Icons.favorite,
                color: isFavorite ? Colors.red : Colors.white,
              ),
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  height: MediaQuery.of(context).size.height / 2.75,
                  url,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Text(
                widget.song[widget.currentIndex].title.toString(),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.song[widget.currentIndex].artist.toString(),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              StreamBuilder(
                stream: _positionStreamController.stream,
                builder: (context, snapshot) {
                  return SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                        trackHeight: 8,
                        thumbShape: const RoundSliderThumbShape(
                            disabledThumbRadius: 8, enabledThumbRadius: 8),
                        overlayShape: const RoundSliderOverlayShape(
                          overlayRadius: 10,
                        ),
                        activeTrackColor: Colors.red,
                        inactiveTrackColor: Colors.grey,
                        thumbColor: Colors.white,
                        overlayColor: Colors.white),
                    child: Slider(
                        min: 0,
                        max: duration.inSeconds.toDouble(),
                        value: position.inSeconds.toDouble(),
                        onChanged: (value) async {
                          final position = Duration(seconds: value.toInt());
                          await audioPlayer.seek(position);
                          await audioPlayer.resume();
                        }),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatTime(position)),
                    Text(formatTime(duration - position)),
                  ],
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                CircleAvatar(
                  radius: 30,
                  child: GestureDetector(
                    onTap: () {
                      if (widget.currentIndex > 0) {
                        playPrevious();
                      } else {
                        return;
                      }
                    },
                    child: Icon(
                      Icons.skip_previous,
                      color: widget.currentIndex == 0
                          ? const Color.fromARGB(255, 121, 120, 120)
                          : Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 30,
                  child: GestureDetector(
                    onTap: () async {
                      if (isPlaying) {
                        await audioPlayer.pause();
                      } else {
                        await audioPlayer.resume();
                      }
                    },
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                CircleAvatar(
                  radius: 30,
                  child: GestureDetector(
                    onTap: () {
                      if (widget.currentIndex < widget.song.length - 1) {
                        playNext();
                      } else {
                        return;
                      }
                    },
                    child: Icon(
                      Icons.skip_next,
                      color: widget.currentIndex == widget.song.length - 1
                          ? const Color.fromARGB(255, 121, 120, 120)
                          : Colors.white,
                      size: 40,
                    ),
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }

  Future<void> setAudio() async {
    // Repeat song when completed
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer
        .setSourceUrl(widget.song[widget.currentIndex].source.toString());
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(duration.inHours);
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, twoDigitMinutes, twoDigitSeconds]
        .join(':');
  }

  void handleAddFavortie() {
    if (isFavorite == true) {
      removeFavoriteSong();
      setState(() {
        isFavorite = false;
      });
    } else {
      addFavoriteSong();
      setState(() {
        isFavorite = true;
      });
    }
  }

  Future<bool> checkIsFavorite() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(
            '${FirebaseAuth.instance.currentUser!.uid}/favorite/${widget.song[widget.currentIndex].id}')
        .get()
        .then((value) {
      if (value.exists) {
        isFavorite = true;
      } else {
        isFavorite = false;
      }
    });
    return isFavorite;
  }
}

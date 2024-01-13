import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PlayerButtons extends StatelessWidget {
  const PlayerButtons({
    Key? key,
    required this.audioPlayer,
  }) : super(key: key);

  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<SequenceState?>(
            stream: audioPlayer.sequenceStateStream,
            builder: (context, index) {
              return IconButton(
                  iconSize: 45,
                  onPressed: audioPlayer.hasPrevious
                      ? audioPlayer.seekToPrevious
                      : null,
                  icon: const Icon(Icons.skip_previous, color: Colors.white));
            }),
        StreamBuilder<PlayerState>(
            stream: audioPlayer.playerStateStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final playerSate = snapshot.data;
                final processingSate = (playerSate!).processingState;
                if (processingSate == ProcessingState.loading ||
                    processingSate == ProcessingState.buffering) {
                  return Container(
                    width: 64,
                    height: 64,
                    margin: const EdgeInsets.all(10),
                    child: const CircularProgressIndicator(),
                  );
                } else if (!audioPlayer.playing) {
                  return IconButton(
                      iconSize: 75,
                      onPressed: (audioPlayer.play),
                      icon: const Icon(
                        Icons.play_circle,
                        color: Colors.white,
                      ));
                } else if (processingSate != ProcessingState.completed) {
                  return IconButton(
                      onPressed: audioPlayer.pause,
                      icon: const Icon(
                        Icons.pause_circle,
                        color: Colors.white,
                      ));
                } else {
                  return IconButton(
                      iconSize: 75,
                      onPressed: () => audioPlayer.seek(Duration.zero,
                          index: audioPlayer.effectiveIndices!.first),
                      icon: const Icon(
                        Icons.replay_circle_filled_outlined,
                        color: Colors.white,
                      ));
                }
              } else {
                return const CircularProgressIndicator();
              }
            }),
        StreamBuilder<SequenceState?>(
            stream: audioPlayer.sequenceStateStream,
            builder: (context, index) {
              return IconButton(
                  iconSize: 45,
                  onPressed:
                      audioPlayer.hasNext ? audioPlayer.seekToNext : null,
                  icon: const Icon(Icons.skip_next, color: Colors.white));
            }),
      ],
    );
  }
}



import 'package:music_app/models/song_model.dart';

class Playlist {
  String? id;
  String? title;
  String? description;
  String? imageUrl;
  List<SongModel> songs = [];

  Playlist({
    required this.id,
    required this.title,
    this.description,
    required this.imageUrl,
    required this.songs,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json["id"],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      songs: (json['songs'] as List<dynamic>)
          .map((song) => SongModel.fromJson(song))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['imageUrl'] = imageUrl;
    data['songs'] = songs.map((song) => song.toJson()).toList();
    return data;
  }
}

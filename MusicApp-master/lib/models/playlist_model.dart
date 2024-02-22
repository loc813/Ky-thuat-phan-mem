import 'package:music_app/models/song_model.dart';

class PlaylistModel {
  String? title; // Tiêu đề của danh sách phát
  List<SongModel>? songs; // Danh sách các bài hát trong danh sách phát
  String? sourceUrl; // URL nguồn của danh sách phát để phát nhạc
  String? artist; // Tên nghệ sĩ của danh sách phát
  String? imageUrl; // URL hình ảnh của danh sách phát

  PlaylistModel({
    this.title,
    this.songs,
    this.sourceUrl,
    this.artist,
    this.imageUrl,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      title: json['title'],
      sourceUrl: json['sourceUrl'], // Lấy giá trị của sourceUrl từ JSON
      artist: json['artist'], // Lấy giá trị của artist từ JSON
      imageUrl: json['imageUrl'], // Lấy giá trị của imageUrl từ JSON
      songs: (json['songs'] as List<dynamic>?)
          ?.map((songJson) => SongModel.fromJson(songJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['sourceUrl'] = sourceUrl; // Thêm giá trị của sourceUrl vào JSON
    data['artist'] = artist; // Thêm giá trị của artist vào JSON
    data['imageUrl'] = imageUrl; // Thêm giá trị của imageUrl vào JSON
    data['songs'] = songs?.map((song) => song.toJson()).toList();
    return data;
  }
}

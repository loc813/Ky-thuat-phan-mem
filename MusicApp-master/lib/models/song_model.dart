class SongModel {
  String? id;
  String? title;
  String? album;
  String? artist;
  String? genre;
  String? source;
  String? image;
  // Thêm thuộc tính description
  String? description;
  int? trackNumber;
  int? totalTrackCount;
  int? duration;
  String? site;

  SongModel({
    required this.id,
    required this.title,
    required this.album,
    required this.artist,
    required this.genre,
    required this.source,
    required this.image,
    this.description, // Không bắt buộc
    required this.trackNumber,
    required this.totalTrackCount,
    required this.duration,
    required this.site,
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json["id"],
      title: json['title'],
      album: json['album'],
      artist: json['artist'],
      genre: json['genre'],
      source: json['source'],
      image: json['image'],
      description: json['description'], // Thêm phần lấy description từ JSON
      trackNumber: json['trackNumber'],
      totalTrackCount: json['totalTrackCount'],
      duration: json['duration'],
      site: json['site'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['album'] = album;
    data['artist'] = artist;
    data['genre'] = genre;
    data['source'] = source;
    data['image'] = image;
    data['description'] = description; // Thêm phần đưa description vào JSON
    data['trackNumber'] = trackNumber;
    data['totalTrackCount'] = totalTrackCount;
    data['duration'] = duration;
    data['site'] = site;
    return data;
  }
}

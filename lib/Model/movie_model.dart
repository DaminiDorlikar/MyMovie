import 'package:hive/hive.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 1)
class MovieModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? posterURL;
  @HiveField(3)
  String? imdbId;

  MovieModel({this.id, this.title, this.posterURL, this.imdbId});

  MovieModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    posterURL = json['posterURL'];
    imdbId = json['imdbId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['posterURL'] = posterURL;
    data['imdbId'] = imdbId;
    return data;
  }
}

import 'package:equatable/equatable.dart';

class HomeEntity extends Equatable {
  final String? blogId;
  final String title;
  final String content;
  final List<String> contentImg; // Changed the type to List<String>
  final String date;
  final String blogCover;
  final bool? isBookmarked;
  final Map<String, dynamic> user;

  const HomeEntity(
      {this.blogId,
      required this.title,
      required this.content,
      required this.contentImg,
      required this.date,
      required this.blogCover,
      this.isBookmarked,
      required this.user});

  factory HomeEntity.fromJson(Map<String, dynamic> json) => HomeEntity(
      blogId: json["blogId"],
      title: json["title"],
      content: json["content"],
      contentImg:
          List<String>.from(json["contentImg"]), // Convert to List<String>
      date: json["date"],
      blogCover: json["blogCover"],
      isBookmarked: json["isBookmarked"],
      user: json["user"]);

  Map<String, dynamic> toJson() => {
        "blogId": blogId,
        "title": title,
        "content": content,
        "contentImg": contentImg,
        "date": date,
        "blogCover": blogCover,
        "isBookmarked": isBookmarked,
        "user": user
      };

  @override
  List<Object?> get props =>
      [blogId, title, content, contentImg, date, blogCover, isBookmarked, user];
}

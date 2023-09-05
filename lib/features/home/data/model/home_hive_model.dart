import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../config/constants/hive_tabel_constant.dart';
import '../../domain/entity/home_entity.dart';

part 'home_hive_model.g.dart';

final homeHiveModelProvider = Provider((ref) => HomeHiveModel.empty());

@HiveType(typeId: HiveTableConstant.blogTableId)
class HomeHiveModel {
  @HiveField(0)
  final String? blogId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final List<String> contentImg; // Changed the type to List<String>

  @HiveField(4)
  final String date; 

  @HiveField(5)
  final String blogCover;

  @HiveField(6)
  final bool? isBookmarked;

  @HiveField(7)
  final Map<String, dynamic> user; // Changed the type to Map<String, dynamic>

  // empty constructor
  HomeHiveModel.empty()
      :     blogId= '',
            title= '',
            content= '',
            contentImg= [],
            date= '',
            blogCover= '',
            isBookmarked= false,
            user= {};

  HomeHiveModel({
    String? blogId,
    required this.title,
    required this.content,
    required this.contentImg,
    required this.date,
    required this.blogCover,
    this.isBookmarked,
    required this.user,
  }) : blogId = blogId ?? const Uuid().v4();

  // Convert Hive Object to Entity
  HomeEntity toEntity() => HomeEntity(
        blogId: blogId,
        title: title,
        content: content,
        contentImg: contentImg,
        date: date,
        blogCover: blogCover,
        isBookmarked: isBookmarked,
        user: user,
      );

  // Convert Entity to Hive Object
  HomeHiveModel toHiveModel(HomeEntity entity) => HomeHiveModel(
        blogId: entity.blogId,
        title: entity.title,
        content: entity.content,
        contentImg: entity.contentImg,
        date: entity.date,
        blogCover: entity.blogCover,
        isBookmarked: entity.isBookmarked,
        user: entity.user,
      );

  // Convert Hive List to Entity List
  List<HomeEntity> toEntityList(List<HomeHiveModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  String toString() {
    return 'blogId: $blogId, title: $title, content: $content, contentImg: $contentImg, date: $date, blogCover: $blogCover'
        'isBookmarked: $isBookmarked, user: $user';
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/home_entity.dart';

part 'home_api_model.g.dart';

final homeApiModelProvider = Provider<HomeApiModel>(
  (ref) => HomeApiModel.empty(),
);

@JsonSerializable()
class HomeApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? blogId;
  final String title;
  final String content;
  final List<String> contentImg; // Changed the type to List<String>
  final String date;
  final String blogCover;
  final bool? isBookmarked;
  final Map<String, dynamic> user;

  const HomeApiModel({
    this.blogId,
    required this.title,
    required this.content,
    required this.contentImg,
    required this.date,
    required this.blogCover,
    this.isBookmarked,
    required this.user,
  });

  HomeApiModel.empty()
      : blogId = '',
        title = '',
        content = '',
        contentImg = [], // Initialize as an empty list
        date = '',
        blogCover = '',
        isBookmarked = false,
        user = {};

  // Convert API Object to Entity
  HomeEntity toEntity() => HomeEntity(
        blogId: blogId ?? '',
        title: title,
        content: content,
        contentImg: contentImg,
        date: date,
        blogCover: blogCover,
        isBookmarked: isBookmarked ?? false,
        user: user,
      );

  // Convert Entity to API Object
  HomeApiModel fromEntity(HomeEntity entity) => HomeApiModel(
        blogId: blogId ?? '',
        title: title,
        content: content,
        contentImg: contentImg,
        date: date,
        blogCover: blogCover,
        isBookmarked: isBookmarked ?? false,
        user: user,
      );

  // Convert API List to Entity List
  List<HomeEntity> toEntityList(List<HomeApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [
        blogId,
        title,
        content,
        contentImg,
        date,
        blogCover,
        isBookmarked,
        user,
      ];

  factory HomeApiModel.fromJson(Map<String, dynamic> json) =>
      _$HomeApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeApiModelToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

import '../model/home_api_model.dart';

part 'get_bookmarked_blogs_dto.g.dart';

@JsonSerializable()
class GetBookmarkedBlogsDTO {
  final List<HomeApiModel> data;

  GetBookmarkedBlogsDTO({
    required this.data,
  });

  factory GetBookmarkedBlogsDTO.fromJson(Map<String, dynamic> json) =>
      _$GetBookmarkedBlogsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetBookmarkedBlogsDTOToJson(this);
}
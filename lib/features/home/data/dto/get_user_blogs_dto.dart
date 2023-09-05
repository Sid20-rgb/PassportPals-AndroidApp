import 'package:json_annotation/json_annotation.dart';

import '../model/home_api_model.dart';


part 'get_user_blogs_dto.g.dart';

@JsonSerializable()
class GetUserBlogsDTO {
  final List<HomeApiModel> data;

  GetUserBlogsDTO({
    required this.data,
  });

  factory GetUserBlogsDTO.fromJson(Map<String, dynamic> json) =>
      _$GetUserBlogsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetUserBlogsDTOToJson(this);
}
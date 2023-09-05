import 'package:json_annotation/json_annotation.dart';

import '../../../home/data/model/home_api_model.dart';

part 'get_searched_blogs_dto.g.dart';

@JsonSerializable()
class GetSearchedBlogsDTO {
  final List<HomeApiModel> data;

  GetSearchedBlogsDTO({
    required this.data,
  });

  factory GetSearchedBlogsDTO.fromJson(Map<String, dynamic> json) =>
      _$GetSearchedBlogsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetSearchedBlogsDTOToJson(this);
}
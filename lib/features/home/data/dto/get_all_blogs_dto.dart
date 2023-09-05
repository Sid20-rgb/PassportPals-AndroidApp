import 'package:json_annotation/json_annotation.dart';

import '../model/home_api_model.dart';

part 'get_all_blogs_dto.g.dart';

@JsonSerializable()
class GetAllBlogDTO {
  final List<HomeApiModel> data;

  GetAllBlogDTO({
    required this.data,
  });

  factory GetAllBlogDTO.fromJson(Map<String, dynamic> json) =>
      _$GetAllBlogDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllBlogDTOToJson(this);
}

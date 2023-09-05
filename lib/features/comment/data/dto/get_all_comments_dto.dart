import 'package:final_mobile/features/comment/data/model/comment_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_all_comments_dto.g.dart';

@JsonSerializable()
class GetAllCommentsDTO {
  final List<CommentApiModel> comments;

  GetAllCommentsDTO({
    required this.comments,
  });

  factory GetAllCommentsDTO.fromJson(Map<String, dynamic> json) =>
      _$GetAllCommentsDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllCommentsDTOToJson(this);
}

import 'package:final_mobile/features/profile/data/model/profile_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_all_dto.g.dart';

@JsonSerializable()
class SearchAllDTO {
  final List<ProfileApiModel> user;

  SearchAllDTO({
    required this.user,
  });

  factory SearchAllDTO.fromJson(Map<String, dynamic> json) =>
      _$SearchAllDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SearchAllDTOToJson(this);
}

import 'package:final_mobile/features/profile/data/model/profile_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_all_user_dto.g.dart';

@JsonSerializable()
class GetAllUsersDTO {
  final List<ProfileApiModel> data;

  GetAllUsersDTO({
    required this.data,
  });

  factory GetAllUsersDTO.fromJson(Map<String, dynamic> json) =>
      _$GetAllUsersDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllUsersDTOToJson(this);
}

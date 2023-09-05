import 'package:final_mobile/features/profile/data/model/profile_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_all_explorer_dto.g.dart';

@JsonSerializable()
class GetAllUserDTO {
  final List<ProfileApiModel> user;

  GetAllUserDTO({
    required this.user,
  });

  factory GetAllUserDTO.fromJson(Map<String, dynamic> json) =>
      _$GetAllUserDTOFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllUserDTOToJson(this);
}

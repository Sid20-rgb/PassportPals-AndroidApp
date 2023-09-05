import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entity/explorer_entity.dart';


part 'explorer_api_model.g.dart';

final explorerApiModelProvider = Provider<ExplorerApiModel>(
  (ref) => ExplorerApiModel.empty(),
);

@JsonSerializable()
class ExplorerApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? userId;
  final String userCover;
  final Map<String, dynamic> user;

  const ExplorerApiModel({
    this.userId,
    required this.userCover,
    required this.user,
  });

  ExplorerApiModel.empty()
      : userId = '',
        userCover = '',
        user = {};

  // Convert API Object to Entity
  ExplorerEntity toEntity() => ExplorerEntity(
        userId: userId ?? '',
        userCover: userCover,
        user: user,
      );

  // Convert Entity to API Object
  ExplorerApiModel fromEntity(ExplorerEntity entity) => ExplorerApiModel(
        userId: userId ?? '',
        userCover: userCover,
        user: user,
      );

  // Convert API List to Entity List
  List<ExplorerEntity> toEntityList(List<ExplorerApiModel> models) =>
      models.map((model) => model.toEntity()).toList();

  @override
  List<Object?> get props => [
        userId,
        userCover,
        user,
      ];

  factory ExplorerApiModel.fromJson(Map<String, dynamic> json) =>
      _$ExplorerApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExplorerApiModelToJson(this);
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_all_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchAllDTO _$SearchAllDTOFromJson(Map<String, dynamic> json) => SearchAllDTO(
      user: (json['user'] as List<dynamic>)
          .map((e) => ProfileApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchAllDTOToJson(SearchAllDTO instance) =>
    <String, dynamic>{
      'user': instance.user,
    };

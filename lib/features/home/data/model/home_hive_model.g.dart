// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HomeHiveModelAdapter extends TypeAdapter<HomeHiveModel> {
  @override
  final int typeId = 1;

  @override
  HomeHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HomeHiveModel(
      blogId: fields[0] as String?,
      title: fields[1] as String,
      content: fields[2] as String,
      contentImg: (fields[3] as List).cast<String>(),
      date: fields[4] as String,
      blogCover: fields[5] as String,
      isBookmarked: fields[6] as bool?,
      user: (fields[7] as Map).cast<String, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, HomeHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.blogId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.contentImg)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.blogCover)
      ..writeByte(6)
      ..write(obj.isBookmarked)
      ..writeByte(7)
      ..write(obj.user);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

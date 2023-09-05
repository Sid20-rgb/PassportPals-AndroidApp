import 'dart:convert';

import 'package:final_mobile/features/home/domain/entity/home_entity.dart';
import 'package:flutter/services.dart';

Future<List<HomeEntity>> getBlogListTest() async {
  final response = await rootBundle.loadString('test_data/home_test_data.json');
  final jsonList = await json.decode(response);
  final List<HomeEntity> homeList = jsonList
      .map<HomeEntity>(
        (json) => HomeEntity.fromJson(json),
      )
      .toList();

  return Future.value(homeList);
}

Future<List<HomeEntity>> getBookmarkedBlogs() async {
  final response =
      await rootBundle.loadString('test_data/bookmarked_blogs_data.json');
  final jsonList = await json.decode(response);

  final List<HomeEntity> bookmarked = jsonList
      .map<HomeEntity>(
        (json) => HomeEntity.fromJson(json),
      )
      .toList();

  return Future.value(bookmarked);
}

Future<List<HomeEntity>> getUserBlogs() async {
  final response =
      await rootBundle.loadString('test_data/user_blogs_data.json');
  final jsonList = await json.decode(response);

  final List<HomeEntity> userBlogs = jsonList
      .map<HomeEntity>(
        (json) => HomeEntity.fromJson(json),
      )
      .toList();

  return Future.value(userBlogs);
}

import 'dart:convert';

import 'package:final_mobile/features/profile/domain/entity/profile_entity.dart';
import 'package:flutter/services.dart';

Future<List<ProfileEntity>> getAllUsers() async {
  final response =
      await rootBundle.loadString('test_data/explorer_entity_test.json');
  final jsonList = await json.decode(response);
  final List<ProfileEntity> explorerList = jsonList
      .map<ProfileEntity>(
        (json) => ProfileEntity.fromJson(json),
      )
      .toList();

  return Future.value(explorerList);
}

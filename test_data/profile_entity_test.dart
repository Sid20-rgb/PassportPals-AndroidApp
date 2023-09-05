import 'dart:convert';

import 'package:final_mobile/features/profile/domain/entity/profile_entity.dart';
import 'package:flutter/services.dart';

Future<List<ProfileEntity>> getAllProfile() async {
  final response =
      await rootBundle.loadString('test_data/profile_entity_test_data.json');
  final jsonList = await json.decode(response);
  final List<ProfileEntity> profileList = jsonList
      .map<ProfileEntity>(
        (json) => ProfileEntity.fromJson(json),
      )
      .toList();

  return Future.value(profileList);
}

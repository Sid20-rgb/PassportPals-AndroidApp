import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:final_mobile/features/explorer/data/dto/search_all_dto.dart';
import 'package:final_mobile/features/profile/data/model/profile_api_model.dart';
import 'package:final_mobile/features/profile/domain/entity/profile_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/api_endpoint.dart';
import '../../../../core/failure/failure.dart';
import '../../../../core/network/remote/http_service.dart';
import '../../../../core/shared_prefs/user_shared_prefs.dart';
import '../dto/get_all_explorer_dto.dart';

final explorerRemoteDataSourceProvider = Provider(
  (ref) => ExplorerRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    explorerApiModel: ref.read(profileApiModelProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class ExplorerRemoteDataSource {
  final Dio dio;
  final ProfileApiModel explorerApiModel;
  final UserSharedPrefs userSharedPrefs;

  ExplorerRemoteDataSource({
    required this.dio,
    required this.explorerApiModel,
    required this.userSharedPrefs,
  });

  Future<Either<Failure, List<ProfileEntity>>> searchAllUsers(
      String search) async {
    try {
      String? token;
      await userSharedPrefs.getUserToken().then(
            (value) => value.fold((l) => null, (r) => token = r),
          );

      final searchEndpoint = '${ApiEndpoints.searchUserBlog}$search';

      var response = await dio.get(
        searchEndpoint,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        SearchAllDTO searchAllDTO = SearchAllDTO.fromJson(response.data);

        return Right(explorerApiModel.toEntityList(searchAllDTO.user));
      } else {
        return Left(
          Failure(
            error: response.statusMessage.toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
        ),
      );
    }
  }

  Future<Either<Failure, List<ProfileEntity>>> getAllUsers() async {
    try {
      String? token;
      await userSharedPrefs.getUserToken().then(
            (value) => value.fold((l) => null, (r) => token = r),
          );

      var response = await dio.get(
        ApiEndpoints.getAllUsers,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200) {
        GetAllUserDTO getAllUserDTO = GetAllUserDTO.fromJson(response.data);

        return Right(explorerApiModel.toEntityList(getAllUserDTO.user));
      } else {
        return Left(
          Failure(
            error: response.statusMessage.toString(),
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.error.toString(),
        ),
      );
    }
  }
}

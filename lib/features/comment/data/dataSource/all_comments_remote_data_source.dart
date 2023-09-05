import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:final_mobile/core/failure/failure.dart';
import 'package:final_mobile/core/network/remote/http_service.dart';
import 'package:final_mobile/core/shared_prefs/user_shared_prefs.dart';
import 'package:final_mobile/features/comment/data/dto/get_all_comments_dto.dart';
import 'package:final_mobile/features/comment/data/model/comment_api_model.dart';
import 'package:final_mobile/features/comment/domain/entity/comment_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/constants/api_endpoint.dart';

final commentRemoteDataSourceProvider = Provider(
  (ref) => CommentsRemoteDataSource(
    dio: ref.read(httpServiceProvider),
    commentApiModel: ref.read(commentApiModelProvider),
    userSharedPrefs: ref.read(userSharedPrefsProvider),
  ),
);

class CommentsRemoteDataSource {
  final Dio dio;
  final CommentApiModel commentApiModel;
  final UserSharedPrefs userSharedPrefs;

  CommentsRemoteDataSource({
    required this.dio,
    required this.commentApiModel,
    required this.userSharedPrefs,
  });

  Future<Either<Failure, List<CommentEntity>>> getAllComments(String id) async {
    try {
      String? token;
      await userSharedPrefs.getUserToken().then(
            (value) => value.fold((l) => null, (r) => token = r),
          );
      String reviewEndPoint =
          '${ApiEndpoints.getAllComments}/$id/${ApiEndpoints.getAllComments}';
      var response = await dio.get(
        reviewEndPoint,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      if (response.statusCode == 200) {
        GetAllCommentsDTO reviews = GetAllCommentsDTO.fromJson(response.data);

        return right(commentApiModel.toEntityList(reviews.comments));
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
          error: e.message.toString(),
        ),
      );
    }
  }

  Future<Either<Failure, bool>> addComment(String content, String id) async {
    try {
      String? token;
      await userSharedPrefs.getUserToken().then(
            (value) => value.fold((l) => null, (r) => token = r),
          );

      String addCommentEndPoint = '${ApiEndpoints.addComment}/$id';

      var requestBody = {
        "content": content,
      };

      var response = await dio.post(
        addCommentEndPoint,
        data: requestBody,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 201) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data['message'],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.message.toString(),
        ),
      );
    }
  }

  Future<Either<Failure, bool>> deleteComment(String id) async {
    try {
      String? token;
      await userSharedPrefs.getUserToken().then(
            (value) => value.fold((l) => null, (r) => token = r),
          );

      String deleteCommentEndPoint = '${ApiEndpoints.deleteComment}/$id/';

      var response = await dio.delete(
        deleteCommentEndPoint,
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 204) {
        return const Right(true);
      } else {
        return Left(
          Failure(
            error: response.data['message'],
            statusCode: response.statusCode.toString(),
          ),
        );
      }
    } on DioException catch (e) {
      return Left(
        Failure(
          error: e.message.toString(),
        ),
      );
    }
  }
}

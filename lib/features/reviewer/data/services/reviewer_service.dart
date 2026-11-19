import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../../creator/data/models/game_models.dart';
import '../models/application_models.dart';

class ReviewerService {
  final ApiClient _apiClient;

  ReviewerService(this._apiClient);

  Future<List<Game>> listGames({String status = 'pending_review'}) async {
    try {
      final response = await _apiClient.dio
          .get('/reviewer/games', queryParameters: {'status': status});
      final list = response.data['games'] as List;
      return list.map((j) => Game.fromJson(j as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Game> approveGame(String id) async {
    try {
      final response =
          await _apiClient.dio.post('/reviewer/games/$id/approve');
      return Game.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Game> rejectGame(String id) async {
    try {
      final response = await _apiClient.dio.post('/reviewer/games/$id/reject');
      return Game.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<CreatorApplication>> listApplications(
      {String status = 'pending'}) async {
    try {
      final response = await _apiClient.dio
          .get('/reviewer/applications', queryParameters: {'status': status});
      final list = response.data['applications'] as List;
      return list
          .map((j) =>
              CreatorApplication.fromJson(j as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> approveApplication(String id) async {
    try {
      await _apiClient.dio.post('/reviewer/applications/$id/approve');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> rejectApplication(String id) async {
    try {
      await _apiClient.dio.post('/reviewer/applications/$id/reject');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

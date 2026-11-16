import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exceptions.dart';
import '../models/game_models.dart';

class GameService {
  final ApiClient _apiClient;

  GameService(this._apiClient);

  Future<Game> createGame({
    required String name,
    required String description,
    required String category,
    required int gridRows,
    required int gridColumns,
    List<String> cardIcons = const [],
    String cardBack = 'classic',
    int timeLimitSeconds = 120,
    int moveLimit = 0,
    int mismatchDelayMs = 1000,
    bool allowHints = true,
  }) async {
    try {
      final response = await _apiClient.dio.post('/games', data: {
        'name': name,
        'description': description,
        'category': category,
        'grid_rows': gridRows,
        'grid_columns': gridColumns,
        'card_icons': cardIcons,
        'card_back': cardBack,
        'time_limit_seconds': timeLimitSeconds,
        'move_limit': moveLimit,
        'mismatch_delay_ms': mismatchDelayMs,
        'allow_hints': allowHints,
      });
      return Game.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Game> submitGame(String id) async {
    try {
      final response = await _apiClient.dio.post('/games/$id/submit');
      return Game.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<List<Game>> listGames({String? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      final response =
          await _apiClient.dio.get('/games', queryParameters: queryParams);
      final list = response.data['games'] as List;
      return list.map((j) => Game.fromJson(j as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Game> getGame(String id) async {
    try {
      final response = await _apiClient.dio.get('/games/$id');
      return Game.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<Game> updateGame(String id, Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.dio.put('/games/$id', data: data);
      return Game.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }

  Future<void> deleteGame(String id) async {
    try {
      await _apiClient.dio.delete('/games/$id');
    } on DioException catch (e) {
      throw ApiException.fromDioException(e);
    }
  }
}

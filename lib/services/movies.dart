import 'package:dio/dio.dart';
import '../services/services.dart';
import '../models/models.dart';
import '../env/env.dart';

class MovieService {
  MovieService(
    this._environmentConfig,
    this._dio,
  );
  final EnvironmentConfig _environmentConfig;
  final Dio _dio;

  Future<List<Movie>> getMovies([int page = 1]) async {
    try {
      final response = await _dio.get(
          'https://api.themoviedb.org/3/movie/popular?api_key=${_environmentConfig.movieApiKey}&language=en-US&page=$page');

      final result = List<Map<String, dynamic>>.from(response.data['results']);
      List<Movie> movies =
          result.map((movie) => Movie.fromMap(movie)).toList(growable: false);
      return movies;
    } on DioError catch (e) {
      throw MoviesException.fromDioError(e);
    }
  }
}

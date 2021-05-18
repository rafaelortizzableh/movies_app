import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../services/services.dart';
import '../state/state.dart';

final movieServiceProvider = Provider<MovieService>(
  (ref) {
    return MovieService(ref.watch(environmentProvider), Dio());
  },
);

// final moviesFutureProvider = FutureProvider.autoDispose<List<Movie>>(
//   (ref) async {
//     ref.maintainState = true;
//     final movieService = ref.read(movieServiceProvider);
//     final movies = await movieService.getMovies();
//     return movies;
//   },
// );

final moviePaginationController =
    StateNotifierProvider<MoviePaginationController, MoviePagination>(
  (ref) {
    final movieService = ref.watch(movieServiceProvider);
    return MoviePaginationController(movieService);
  },
);

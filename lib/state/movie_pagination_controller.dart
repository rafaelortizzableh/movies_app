import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/services.dart';

class MoviePaginationController extends StateNotifier<MoviePagination> {
  MoviePaginationController(
    this._movieService, [
    MoviePagination state,
  ]) : super(state ?? MoviePagination.initail()) {
    getMovies();
  }

  MovieService _movieService;

  Future<void> getMovies() async {
    try {
      final movies = await _movieService.getMovies(state.page);
      state = state
          .copyWith(movies: [...state.movies, ...movies], page: state.page + 1);
    } on MoviesException catch (e) {
      state = state.copyWith(errorMessage: e.message);
    }
  }

  void handleScrollWithIndex(int index) {
    final int itemPosition = index + 1;
    final bool requestMoreData = itemPosition % 20 == 0 && itemPosition != 0;
    final int pageToRequest = itemPosition ~/ 20;
    if (requestMoreData && pageToRequest + 1 >= state.page) {
      getMovies();
    }
  }
}

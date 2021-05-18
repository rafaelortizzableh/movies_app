import 'package:collection/collection.dart';
import 'models.dart';

class MoviePagination {
  final List<Movie> movies;
  final int page;
  final String errorMessage;
  MoviePagination({
    this.movies,
    this.page,
    this.errorMessage,
  });

  MoviePagination.initail()
      : movies = [],
        page = 1,
        errorMessage = '';

  MoviePagination copyWith({
    List<Movie> movies,
    int page,
    String errorMessage,
  }) {
    return MoviePagination(
      movies: movies ?? this.movies,
      page: page ?? this.page,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get refreshError => errorMessage != '' && movies.length <= 20;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other is MoviePagination &&
        listEquals(other.movies, movies) &&
        other.page == page &&
        other.errorMessage == errorMessage;
  }

  @override
  int get hashCode => movies.hashCode ^ page.hashCode ^ errorMessage.hashCode;
}

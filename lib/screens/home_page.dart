import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import '../services/services.dart';

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final paginationState = watch(moviePaginationController);
    final paginationController = watch(moviePaginationController.notifier);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.dark,
        centerTitle: true,
        title: Text('Movie App'),
      ),
      body: Builder(builder: (context) {
        if (paginationState.refreshError) {
          return _ErrorWidget(message: paginationState.errorMessage);
        } else if (paginationState.movies.isEmpty) {
          return Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return RefreshIndicator(
          onRefresh: () {
            return context.refresh(moviePaginationController).getMovies();
          },
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 0,
              childAspectRatio: 0.7,
              crossAxisSpacing: 0,
            ),
            itemCount: paginationState.movies.length,
            itemBuilder: (context, index) {
              paginationController.handleScrollWithIndex(index);
              return _MovieBox(movie: paginationState.movies[index]);
            },
          ),
        );
      }),

      // watch(moviesFutureProvider).when(
      //   error: (e, s) {
      //     if (e is MoviesException) {
      //       return _ErrorWidget(message: e.message);
      //     }
      //     return _ErrorWidget(message: "Oops, something unexpected happened");
      //   },
      //   loading: () {
      //     return Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   },
      //   data: (movies) {
      //     return RefreshIndicator(
      //       onRefresh: () {
      //         return context.refresh(moviesFutureProvider);
      //       },
      //       child: GridView.extent(
      //         maxCrossAxisExtent: 200,
      //         mainAxisSpacing: 0,
      //         childAspectRatio: 0.7,
      //         children: movies.map((movie) => _MovieBox(movie: movie)).toList(),
      //       ),
      //     );
      //   },
      // ),
    );
  }
}

class _MovieBox extends StatelessWidget {
  const _MovieBox({Key key, @required this.movie}) : super(key: key);
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          movie.fullImageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: _FrontBanner(text: movie.title),
        ),
      ],
    );
  }
}

class _FrontBanner extends StatelessWidget {
  const _FrontBanner({Key key, @required this.text})
      : assert(text != null),
        super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 60,
          color: Colors.grey.shade200.withOpacity(0.5),
          child: Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({Key key, @required this.message})
      : assert(message != null, 'A non-null String must be provided'),
        super(key: key);
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message),
          ElevatedButton(
            onPressed: () {
              context.refresh(moviePaginationController).getMovies();
            },
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

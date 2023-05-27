import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:themoviedb/ui/widgets/movie_list/movie_list_view_model.dart';
import 'package:themoviedb/domain/api_client/image_downloader.dart';

class MovieListWidget extends StatefulWidget {
  const MovieListWidget({super.key});

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    context.read<MovieListViewModel>().setupLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        _MovieListWidgetBody(),
        _SearchWidget(),
      ],
    );
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieListViewModel>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: model.searchMovie,
        decoration: InputDecoration(
          labelText: 'Поиск',
          filled: true,
          fillColor: Colors.white.withAlpha(235),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _MovieListWidgetBody extends StatelessWidget {
  const _MovieListWidgetBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieListViewModel>();

    return ListView.builder(
      padding: const EdgeInsets.only(top: 66),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: model.movies.length,
      itemExtent: 163,
      itemBuilder: (context, index) {
        model.showedMovieAtIndex(index);
        return _MovieListRowWidget(index: index);
      },
    );
  }
}

class _MovieListRowWidget extends StatelessWidget {
  final int index;

  const _MovieListRowWidget({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieListViewModel>();
    final movie = model.movies[index];
    final posterPath = movie.posterPath;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: Colors.black.withOpacity(0.2),
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            clipBehavior: Clip.hardEdge,
            child: Row(
              children: [
                if (posterPath != null)
                  Image.network(
                    ImageDownloader.imageUrl(posterPath),
                    width: 95,
                  ),
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        movie.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        movie.releaseDate,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        movie.overview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () => model.onMovieTap(context, index),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:themoviedb/ui/widgets/movie_details/movie_details_widget_model.dart';
import 'package:themoviedb/Library/Widgets/Inherited/provider.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';

class MovieDetailsMainScreenCastWidget extends StatelessWidget {
  const MovieDetailsMainScreenCastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Top Billed Cast',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 250,
            child: Scrollbar(
              thickness: 5,
              child: _ActorsListWidget(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextButton(
              onPressed: () {},
              child: const Text('Full Cast & Crew'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActorsListWidget extends StatelessWidget {
  const _ActorsListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieDetailsWidgetModel>(context);
    var cast = model?.movieDetails?.credits.cast;
    if (cast == null || cast.isEmpty) return const SizedBox.shrink();

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 20,
      itemExtent: 120,
      itemBuilder: (context, index) {
        return _ActorListItemWidget(
          actorIndex: index,
        );
      },
    );
  }
}

class _ActorListItemWidget extends StatelessWidget {
  final int actorIndex;

  const _ActorListItemWidget({
    super.key,
    required this.actorIndex,
  });

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.read<MovieDetailsWidgetModel>(context);
    final actor = model!.movieDetails!.credits.cast[actorIndex];
    final profilePath = actor.profilePath;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
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
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profilePath != null
                  ? Image.network(
                      ApiClient.imageUrl(profilePath),
                      height: 120,
                      width: 120,
                      fit: BoxFit.fitWidth,
                    )
                  : const SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      actor.name,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      actor.character,
                      maxLines: 4,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

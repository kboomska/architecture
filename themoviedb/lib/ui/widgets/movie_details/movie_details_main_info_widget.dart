import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:themoviedb/ui/widgets/movie_details/movie_details_widget_model.dart';
import 'package:themoviedb/ui/widgets/elements/radial_percent_widget.dart';
import 'package:themoviedb/domain/api_client/image_downloader.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _TopPostersWidget(),
        Padding(
          padding: EdgeInsets.all(15.0),
          child: _MovieNameWidget(),
        ),
        _ScoreWidget(),
        _SummaryWidget(),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: _OverviewWidget(),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
          child: _DescriptionWidget(),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: _CrewWidget(),
        ),
      ],
    );
  }
}

class _DescriptionWidget extends StatelessWidget {
  const _DescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final overview = context.select(
      (MovieDetailsWidgetModel model) => model.data.overview,
    );

    return Text(
      overview,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _OverviewWidget extends StatelessWidget {
  const _OverviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Overview',
        textAlign: TextAlign.start,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _TopPostersWidget extends StatelessWidget {
  const _TopPostersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieDetailsWidgetModel>();
    final posterData = context.select(
      (MovieDetailsWidgetModel model) => model.data.posterData,
    );
    final backdropPath = posterData.backdropPath;
    final posterPath = posterData.posterPath;

    return AspectRatio(
      aspectRatio: 390 / 219,
      child: Stack(
        children: [
          if (backdropPath != null)
            Image.network(ImageDownloader.imageUrl(backdropPath)),
          if (posterPath != null)
            Positioned(
              top: 20,
              left: 20,
              bottom: 20,
              child: Image.network(
                ImageDownloader.imageUrl(posterPath),
              ),
            ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              onPressed: () => model.toggleFavorite(context),
              icon: Icon(
                posterData.favoriteIcon,
                color: Colors.amber,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final titleData = context.select(
      (MovieDetailsWidgetModel model) => model.data.titleData,
    );

    return Center(
      child: RichText(
        maxLines: 3,
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: titleData.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: titleData.year,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final scoreData = context.select(
      (MovieDetailsWidgetModel model) => model.data.scoreData,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(
          onPressed: () {},
          child: Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: RadialPercentWidget(
                  percent: scoreData.voteAverage / 100,
                  fillColor: const Color.fromARGB(255, 10, 23, 25),
                  lineColor: const Color.fromARGB(255, 37, 203, 103),
                  freeColor: const Color.fromARGB(255, 25, 54, 31),
                  lineWidth: 3,
                  linePadding: 2,
                  child: Text(
                    scoreData.voteAverage.toStringAsFixed(0),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                'User Score',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Container(width: 1, height: 15, color: Colors.grey),
        scoreData.trailerKey != null
            ? TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    MainNavigationRouteNames.movieTrailer,
                    arguments: scoreData.trailerKey,
                  );
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Play Trailer',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            : Row(
                children: const [
                  Icon(
                    Icons.play_arrow,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Play Trailer',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}

class _SummaryWidget extends StatelessWidget {
  const _SummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final summary =
        context.select((MovieDetailsWidgetModel model) => model.data.summary);

    return ColoredBox(
      color: const Color.fromRGBO(22, 21, 25, 1),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        child: Text(
          summary,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _CrewWidget extends StatelessWidget {
  const _CrewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final crewData = context.select(
      (MovieDetailsWidgetModel model) => model.data.crewData,
    );

    return Column(
      children: crewData
          .map(
            (chunk) => Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: _CrewWidgetRow(employees: chunk),
            ),
          )
          .toList(),
    );
  }
}

class _CrewWidgetRow extends StatelessWidget {
  final List<MovieDetailsCrewData> employees;

  const _CrewWidgetRow({super.key, required this.employees});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: employees
          .map(
            (employee) => _CrewWidgetRowItem(
              employee: employee,
            ),
          )
          .toList(),
    );
  }
}

class _CrewWidgetRowItem extends StatelessWidget {
  final MovieDetailsCrewData employee;

  const _CrewWidgetRowItem({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    const staffStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    );

    const jobTitleStyle = TextStyle(
      color: Colors.white,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(employee.name, style: staffStyle),
          Text(employee.job, style: jobTitleStyle),
        ],
      ),
    );
  }
}

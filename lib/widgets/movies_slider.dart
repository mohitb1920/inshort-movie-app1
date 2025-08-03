import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutflix/constants.dart';
import 'package:flutflix/models/movie.dart';
import 'package:flutter/material.dart';

import '../screens/details_screen.dart';

class MoviesSlider extends StatefulWidget {
  final List<Movie> movies;
  const MoviesSlider({super.key, required this.movies});

  @override
  State<MoviesSlider> createState() => _MoviesSliderState();
}

class _MoviesSliderState extends State<MoviesSlider> {
  @override
  Widget build(BuildContext context) {
    return widget.movies.isEmpty
        ? const CircularProgressIndicator()
        : SizedBox(
            height: 200,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.movies.length,
              itemBuilder: (context, itemIndex) {
                final movie = widget.movies[itemIndex];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailsScreen(movie: movie),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                          height: 200,
                          width: 150,
                          child: CachedNetworkImage(
                            imageUrl: movie.posterPath != null &&
                                    movie.posterPath.isNotEmpty
                                ? '${Constants.imagePath}${movie.posterPath}'
                                : '',
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.broken_image, color: Colors.grey),
                          )),
                    ),
                  ),
                );
              },
            ),
          );
  }
}

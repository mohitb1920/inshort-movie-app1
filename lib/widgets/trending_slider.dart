import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutflix/constants.dart';
import 'package:flutflix/models/movie.dart';
import 'package:flutflix/screens/details_screen.dart';
import 'package:flutter/material.dart';

class TrendingSlider extends StatefulWidget {
  final List<Movie> movies;
  const TrendingSlider({super.key, required this.movies});

  @override
  State<TrendingSlider> createState() => _TrendingSliderState();
}

class _TrendingSliderState extends State<TrendingSlider> {
  @override
  Widget build(BuildContext context) {
    return widget.movies.isEmpty
        ? const CircularProgressIndicator()
        : SizedBox(
            width: double.infinity,
            child: CarouselSlider.builder(
              itemCount: widget.movies.length,
              options: CarouselOptions(
                height: 300,
                autoPlay: true,
                viewportFraction: 0.55,
                enlargeCenterPage: true,
                pageSnapping: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                autoPlayAnimationDuration: const Duration(seconds: 1),
              ),
              itemBuilder: (context, itemIndex, pageViewIndex) {
                final movie = widget.movies[itemIndex];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(movie: movie),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 300,
                      width: 200,
                      child: CachedNetworkImage(
                        imageUrl: movie.posterPath != null &&
                                movie.posterPath.isNotEmpty
                            ? '${Constants.imagePath}${movie.posterPath}'
                            : '',
                        fit: BoxFit.cover,
                        filterQuality: FilterQuality.high,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}

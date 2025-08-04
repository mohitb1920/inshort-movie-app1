import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutflix/colors.dart';
import 'package:flutflix/constants.dart';
import 'package:flutflix/controller/home_screen_controller.dart';
import 'package:flutflix/models/movie.dart';
import 'package:flutflix/widgets/back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Add GetX
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    super.key,
    required this.movie,
  });
  final Movie movie;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final controller = Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            leading: const BackBtn(),
            backgroundColor: Colours.scaffoldBgColor,
            expandedHeight: 500,
            pinned: true,
            floating: true,
            actions: [
              IconButton(
                icon: Icon(
                  Icons.share,
                ),
                onPressed: () {
                  final deepLink =
                      'https://flutflix.com/movie/${widget.movie.movieId}';
                  final message =
                      '${widget.movie.title}\n\nCheck out this movie!\n$deepLink';
                  Share.share(message);
                },
              ),
              Obx(() {
                final isBookmarked = controller.bookmarkedMovies
                    .any((m) => m.movieId == widget.movie.movieId);
                return IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    controller.toggleBookmark(widget.movie);
                  },
                );
              }),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.movie.title,
                style: GoogleFonts.belleza(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.movie.posterPath.isNotEmpty
                      ? '${Constants.imagePath}${widget.movie.posterPath}'
                      : '',
                  fit: BoxFit.cover,
                  filterQuality: FilterQuality.high,
                  placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2)),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    'Overview',
                    style: GoogleFonts.openSans(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.movie.overview,
                    style: GoogleFonts.roboto(
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _infoBox('Release date:', widget.movie.releaseDate),
                        _infoBox(
                          'Rating:',
                          '${widget.movie.voteAverage.toStringAsFixed(1)}/10',
                          icon: Icons.star,
                          iconColor: Colors.amber,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox(String label, String value,
      {IconData? icon, Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(
            '$label ',
            style: GoogleFonts.roboto(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (icon != null) Icon(icon, color: iconColor ?? Colors.grey),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

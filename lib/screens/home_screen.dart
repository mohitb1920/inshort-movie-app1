import 'package:flutflix/controller/home_screen_controller.dart';
import 'package:flutflix/models/movie.dart';
import 'package:flutflix/screens/details_screen.dart';
import 'package:flutflix/screens/saved_movies.dart';
import 'package:flutflix/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:uni_links/uni_links.dart';
import '../widgets/movies_slider.dart';
import '../widgets/trending_slider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenController controller = Get.put(HomeScreenController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          'assets/flutflix.png',
          fit: BoxFit.cover,
          height: 40,
          filterQuality: FilterQuality.high,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search_rounded,
              color: Color.fromARGB(255, 241, 238, 238),
            ),
            onPressed: () {
              controller.searchTextController.clear();
              controller.searchMovieList.clear();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.red),
            tooltip: 'Saved Movies',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SavedMoviesPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Obx(
        () => controller.trendingMovies.isEmpty &&
                controller.nowPlayingMovies.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trending Movies',
                        style: GoogleFonts.aBeeZee(fontSize: 25),
                      ),
                      const SizedBox(height: 32),
                      TrendingSlider(movies: controller.trendingMovies),
                      const SizedBox(height: 32),
                      Text(
                        'Now Playing Movies',
                        style: GoogleFonts.aBeeZee(fontSize: 25),
                      ),
                      const SizedBox(height: 32),
                      MoviesSlider(movies: controller.nowPlayingMovies),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

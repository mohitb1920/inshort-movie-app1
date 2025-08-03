import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutflix/constants.dart';
import 'package:flutflix/controller/home_screen_controller.dart';
import 'package:flutflix/models/movie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SavedMoviesPage extends StatefulWidget {
  const SavedMoviesPage({super.key});

  @override
  State<SavedMoviesPage> createState() => _SavedMoviesPageState();
}

class _SavedMoviesPageState extends State<SavedMoviesPage> {
  late HomeScreenController homeScreenController;

  @override
  void initState() {
    super.initState();
    homeScreenController = Get.find<HomeScreenController>();
    homeScreenController.loadBookmarkedMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarked Movies"),
        backgroundColor: Color.fromARGB(255, 243, 109, 100),
      ),
      body: Obx(() {
        return homeScreenController.bookmarkedMovies.isEmpty
            ? Center(child: Text("No bookmarked movies found."))
            : Padding(
                padding: const EdgeInsets.only(top: 2),
                child: ListView.builder(
                  itemCount: homeScreenController.bookmarkedMovies.length,
                  itemBuilder: (context, index) {
                    final movie = homeScreenController.bookmarkedMovies[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 2, bottom: 2),
                      child: ListTile(
                        leading: SizedBox(
                          width: 60,
                          height: 90,
                          child: CachedNetworkImage(
                            imageUrl: movie.posterPath != null &&
                                    movie.posterPath.isNotEmpty
                                ? '${Constants.imagePath}${movie.posterPath}'
                                : '',
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.high,
                            placeholder: (context, url) => const Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2)),
                            errorWidget: (context, url, error) => const Icon(
                                Icons.broken_image,
                                color: Colors.grey),
                          ),
                        ),
                        title: Text(movie.title),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await homeScreenController.toggleBookmark(movie);
                          },
                        ),
                      ),
                    );
                  },
                ),
              );
      }),
    );
  }
}

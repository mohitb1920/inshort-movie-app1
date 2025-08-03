import 'dart:async';

import 'package:flutflix/controller/home_screen_controller.dart';
import 'package:flutflix/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';

class SearchPage extends StatefulWidget {
  SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final controller = Get.find<HomeScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Movies"),
        backgroundColor: Color.fromARGB(255, 243, 109, 100),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: controller.searchTextController,
              onChanged: (text) {
                if (controller.debounce?.isActive ?? false)
                  controller.debounce!.cancel();
                controller.debounce =
                    Timer(const Duration(milliseconds: 500), () {
                  controller.searchMovies(text);
                });
              },
              decoration: InputDecoration(
                hintText: "Search movies...",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.searchMovieList.isEmpty &&
                    controller.searchTextController.text.isNotEmpty) {
                  return const Center(child: Text("No movies found."));
                }

                return ListView.builder(
                  itemCount: controller.searchMovieList.length,
                  itemBuilder: (context, index) {
                    final movie = controller.searchMovieList[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailsScreen(movie: movie),
                          ),
                        );
                      },
                      child: ListTile(
                        leading: Image.network(
                          '${Constants.imagePath}${movie.posterPath}',
                          width: 50,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.broken_image),
                        ),
                        title: Text(movie.title),
                        subtitle: Text(movie.releaseDate),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

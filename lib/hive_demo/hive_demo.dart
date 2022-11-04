import 'dart:math';

import 'package:demo_app/hive_demo/models/movie_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'dart:developer' as devtools show log;

class MyMovieList extends StatefulWidget {
  const MyMovieList({super.key});

  @override
  State<MyMovieList> createState() => _MyMovieListState();
}

class _MyMovieListState extends State<MyMovieList> {
  late Box<Movie> moviesBox;

  @override
  void initState() {
    super.initState();
    moviesBox = Hive.box('my_movie_list');
    devtools.log('Movies: ${moviesBox.values}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Demo'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.clear),
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: moviesBox.listenable(),
        builder: (context, Box<Movie> box, _) {
          List<Movie> movies = box.values.toList().cast<Movie>();

          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              Movie movie = movies[index];
              return ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: Image.network(
                  movie.imageUrl,
                  fit: BoxFit.cover,
                  width: 100,
                ),
                title: Text(movie.name),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        moviesBox.put(
                          movie.id,
                          movie.copyWith(
                              addedToWatchList: !movie.addedToWatchList),
                        );
                      },
                      icon: Icon(
                        Icons.watch_later_sharp,
                        color: movie.addedToWatchList
                            ? Colors.grey
                            : Theme.of(context).primaryColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _showModalBottomSheet(
                          context: context,
                          moviesBox: moviesBox,
                          movie: movie,
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        box.delete(movie.id);
                      },
                      icon: const Icon(Icons.delete),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showModalBottomSheet(
          context: context,
          moviesBox: moviesBox,
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showModalBottomSheet({
    required BuildContext context,
    required Box moviesBox,
    Movie? movie,
  }) {
    Random random = Random();
    TextEditingController nameController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();

    if (movie != null) {
      nameController.text = movie.name;
      imageUrlController.text = movie.imageUrl;
    }

    showModalBottomSheet(
      isDismissible: true,
      isScrollControlled: true,
      elevation: 5,
      context: context,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(labelText: 'Movie'),
            ),
            TextField(
              controller: imageUrlController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (movie != null) {
                  moviesBox.put(
                    movie.id,
                    movie.copyWith(
                      name: nameController.text,
                      imageUrl: imageUrlController.text,
                    ),
                  );
                  Navigator.pop(context);
                } else {
                  Movie movie = Movie(
                    id: '${random.nextInt(10000)}',
                    name: nameController.text,
                    imageUrl: imageUrlController.text,
                    addedToWatchList: false,
                  );

                  moviesBox.put(movie.id, movie);
                  // or moviesBox.add(movie);

                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

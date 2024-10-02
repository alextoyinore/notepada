import 'package:flutter/material.dart';
import 'package:notepada/common/widgets/appbar.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/features/note/presentation/pages/favourite_notes.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  final _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, searchController: _searchController),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.notes,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppGaps.v10,
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              child: const FavouriteNotes(),
            ),
          ],
        ),
      ),
    );
  }
}

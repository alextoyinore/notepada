import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notepada/common/widgets/appbar.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, searchController: _searchController),
      body: Center(
        child: Text('Favourites'),
      ),
    );
  }
}

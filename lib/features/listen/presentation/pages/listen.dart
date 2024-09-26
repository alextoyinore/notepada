import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:notepada/common/widgets/appbar.dart';

class Listen extends StatefulWidget {
  const Listen({super.key});

  @override
  State<Listen> createState() => _ListenState();
}

class _ListenState extends State<Listen> {
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, searchController: _searchController),
      body: Center(
        child: Text('Listen'),
      ),
    );
  }
}

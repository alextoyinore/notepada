import 'package:flutter/material.dart';
import 'package:notepada/common/widgets/appbar.dart';

class DashContent extends StatefulWidget {
  const DashContent({super.key});

  @override
  State<DashContent> createState() => _DashContentState();
}

class _DashContentState extends State<DashContent> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context: context, searchController: _searchController),
      body: const Center(
        child: Text('Dash Content'),
      ),
    );
  }
}

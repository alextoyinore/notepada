import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/common/widgets/appbar.dart';
import 'package:notepada/config/assets/vectors.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/core/routes/names.dart';

class DashContent extends StatefulWidget {
  const DashContent({super.key});

  @override
  State<DashContent> createState() => _DashContentState();
}

class _DashContentState extends State<DashContent> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(null, context, _searchController),
      body: Center(
        child: Text('Dash Content'),
      ),
    );
  }
}

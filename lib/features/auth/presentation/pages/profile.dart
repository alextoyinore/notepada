import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/core/routes/names.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: IconButton(
          padding: const EdgeInsets.only(left: 20),
          onPressed: () => context.goNamed(RouteNames.home),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.darkGrey,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}

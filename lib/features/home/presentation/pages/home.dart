import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/config/assets/vectors.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/core/routes/routes.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   title: SvgPicture.asset(
      //     AppVectors.logo,
      //     height: 40,
      //     color: AppColors.primary,
      //   ),
      //   actions: [
      //     IconButton(
      //       onPressed: () {},
      //       icon: const Icon(Icons.person_outlined),
      //     ),
      //   ],
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppGaps.v40,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset(
                    AppVectors.icon,
                    height: 60,
                    color: AppColors.primary,
                  ),
                  Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: SvgPicture.asset(
                      AppVectors.profile,
                      height: 60,
                      color: AppColors.primary,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
              AppGaps.v20,
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Write Chapter One of Book',
                      style: AppStyles.noteListHeaderStyle,
                    ),
                    AppGaps.v10,
                    const Text(
                        'Need to write the first chapter of the book. I need to create characers and event timelines'),
                    AppGaps.v10,
                    const Text(
                      '26/08/1990',
                      style: TextStyle(color: AppColors.midGrey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(RouteNames.newNote);
        },
        child: const Icon(
          Icons.mode_edit_outline_outlined,
        ),
      ),
    );
  }
}

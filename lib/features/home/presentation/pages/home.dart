import 'package:flutter/gestures.dart';
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppGaps.v50,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // SvgPicture.asset(
                  //   AppVectors.icon,
                  //   height: 40,
                  //   color: AppColors.primary,
                  // ),
                  const Text(
                    AppStrings.notes,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: AppColors.midGrey,
                        width: 1,
                      ),
                    ),
                    child: const Icon(Icons.person),
                  )
                ],
              ),
              AppGaps.v20,
              Dismissible(
                key: UniqueKey(),
                background: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                // secondaryBackground: const Icon(
                //   Icons.delete,
                //   color: AppColors.bright,
                // ),
                confirmDismiss: (DismissDirection direction) async {
                  // Your confirmation logic goes here
                  // Return true to allow dismissal, false to prevent it
                  return true;
                },
                onDismissed: (DismissDirection direction) {},
                onResize: () {},
                direction: DismissDirection.endToStart,
                dragStartBehavior: DragStartBehavior.start,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.grey.withOpacity(.2),
                    borderRadius: BorderRadius.circular(10),
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
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(RouteNames.editNote);
        },
        child: const Icon(
          Icons.mode_edit_outline_outlined,
        ),
      ),
    );
  }
}

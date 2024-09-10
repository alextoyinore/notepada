import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/config/theme/styles.dart';

import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/core/routes/routes.dart';

class EditNote extends StatefulWidget {
  const EditNote({super.key});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        child: Column(
          children: [
            AppGaps.v40,
            TextField(
              decoration: AppStyles.lightTextFieldThemeBorderless.copyWith(
                hintText: AppStrings.titleHintText,
                hintStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              minLines: 1,
              maxLines: 2,
            ),
            AppGaps.v10,
            TextField(
              decoration: AppStyles.lightTextFieldThemeBorderless.copyWith(
                hintText: AppStrings.noteHintText,
                border: const UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              minLines: 25,
              maxLines: 120,
            ),
            AppGaps.v20,
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                children: [
                  ElevatedButton(
                    // style: ButtonStyle(shape: ),
                    onPressed: () {},
                    child: const Text(AppStrings.addNote),
                  ),
                  AppGaps.v10,
                  TextButton(
                      onPressed: () {
                        context.goNamed(RouteNames.home);
                      },
                      child: const Text(AppStrings.cancel))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


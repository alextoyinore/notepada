import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/config/theme/styles.dart';

import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/core/routes/names.dart';
import 'package:notepada/core/routes/routes.dart';

class NewNote extends StatefulWidget {
  const NewNote({super.key});

  @override
  State<NewNote> createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
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
              ),
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
            AppGaps.v10,
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
                      }, child: const Text(AppStrings.cancel))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

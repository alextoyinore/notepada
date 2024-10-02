import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:notepada/common/helpers/helpers.dart';
import 'package:notepada/common/sources/local/lists.dart';
import 'package:notepada/common/sources/local/translate_dropdown.dart';
import 'package:notepada/config/strings/strings.dart';
import 'package:notepada/config/theme/colors.dart';
import 'package:notepada/config/theme/styles.dart';
import 'package:notepada/core/util/storage/storage_keys.dart';
import 'package:notepada/core/util/storage/storage_service.dart';
import 'package:translator/translator.dart';

class Translator extends StatefulWidget {
  const Translator({super.key});

  @override
  State<Translator> createState() => _TranslatorState();
}

class _TranslatorState extends State<Translator> {
  String fromLanguageCode = 'en';
  String fromLanguageName = 'English';
  String toLanguageCode = 'fr';
  String toLanguageName = 'French';

  final TextEditingController _textToTranslateController =
      TextEditingController();
  final TextEditingController _translatedTextController =
      TextEditingController();

  final _storedDefaultColor = StorageService();

  late Color _defaultColor;

  @override
  void initState() {
    super.initState();
    _defaultColor = Color(
        int.tryParse(_storedDefaultColor.getValue(StorageKeys.defaultColor)!)!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppGaps.v10,
                Text(
                  AppStrings.translate,
                  style: AppStyles.headerStyle,
                ),
                AppGaps.v10,
                const Text(
                  AppStrings.translateDescription,
                  style: TextStyle(
                    color: AppColors.midGrey,
                    fontSize: 16,
                  ),
                ),
                AppGaps.v20,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton(
                      elevation: 0,
                      underline: Container(),
                      hint: const Text(AppStrings.fromLanguage),
                      items: getLanguages(),
                      value: fromLanguageCode,
                      onChanged: (value) {
                        setState(() {
                          fromLanguageCode = value ?? 'en';
                          fromLanguageName = value ?? 'English';
                        });
                      },
                    ),
                    AppGaps.h10,
                    DropdownButton(
                      elevation: 0,
                      underline: Container(),
                      hint: Text(toLanguageName),
                      items: getLanguages(),
                      value: toLanguageCode,
                      onChanged: (value) {
                        setState(() {
                          toLanguageCode = value ?? 'fr';
                          toLanguageName = value ?? 'French';
                        });
                      },
                    ),
                  ],
                ),
                AppGaps.v20,
                Divider(
                  height: 1,
                  thickness: .5,
                  color: _defaultColor.withOpacity(.2),
                ),
                AppGaps.v20,
                TextField(
                  scrollController: ScrollController(),
                  controller: _textToTranslateController,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: AppLists.languages[fromLanguageCode],
                    hintStyle: const TextStyle(
                      color: AppColors.grey,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                  maxLines: 5000,
                  minLines: 8,
                ),
                AppGaps.v20,
                Divider(
                  height: 1,
                  thickness: .5,
                  color: _defaultColor.withOpacity(.2),
                ),
                AppGaps.v20,
                Stack(
                  children: [
                    _translatedTextController.text.isNotEmpty
                        ? Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              color: _defaultColor,
                              onPressed: () => ttsSpeak(
                                text: _translatedTextController.text.toString(),
                                context: context,
                                language: AppLists.ttsLanguage[toLanguageCode]!,
                              ),
                              icon: const Icon(
                                Icons.volume_up,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    TextField(
                      scrollController: ScrollController(),
                      controller: _translatedTextController,
                      style: TextStyle(
                        color: _defaultColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        hintText: AppLists.languages[toLanguageCode],
                        hintStyle: const TextStyle(
                          color: AppColors.grey,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      maxLines: 5000,
                      minLines: 8,
                    ),
                  ],
                ),
                AppGaps.v20,
                ElevatedButton(
                  onPressed: translate,
                  child: const Text(AppStrings.translate),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void translate() async {
    final translator = GoogleTranslator();
    final input = _textToTranslateController.text;
    var translation = await translator.translate(input,
        from: fromLanguageCode, to: toLanguageCode);
    setState(() {
      _translatedTextController.text = translation.text;
    });
  }
}

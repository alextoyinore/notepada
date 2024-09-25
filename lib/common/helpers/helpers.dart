import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:notepada/common/bloc/settings/settings_cubit.dart';

/// Darken a color by [percent] amount (100 = black)

Color darken(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  return Color.fromARGB(
    c.alpha,
    (c.red * f).round(),
    (c.green * f).round(),
    (c.blue * f).round(),
  );
}

/// Lighten a color by [percent] amount (100 = white)

Color lighten(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var p = percent / 100;
  return Color.fromARGB(
      c.alpha,
      c.red + ((255 - c.red) * p).round(),
      c.green + ((255 - c.green) * p).round(),
      c.blue + ((255 - c.blue) * p).round());
}

/// Prevent Keyboard from appearing

class FirstTapDisableFocusNode extends FocusNode {
  @override
  bool consumeKeyboardToken() {
    return false;
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

String toHumanReadableDate(String isoString) {
  DateTime dateTime = DateTime.parse(isoString);
  // Format date
  String formattedDate = DateFormat.yMMMd().add_jm().format(dateTime);
  return formattedDate;
}

final FlutterTts flutterTts = FlutterTts();

Future<void> ttsSpeak(
    {required String text, required BuildContext context}) async {
  await flutterTts.setLanguage('en-US');
  await flutterTts.setVolume(context.read<VoiceVolumeCubit>().state / 100);
  await flutterTts.setSpeechRate(context.read<VoiceRateCubit>().state / 100);
  await flutterTts.setPitch(context.read<VoicePitchCubit>().state / 100);
  await flutterTts.speak(text);
}

Future<void> ttsStop() async {
  await flutterTts.stop();
}

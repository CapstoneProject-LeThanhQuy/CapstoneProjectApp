import 'dart:math';

import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';

class CommonTextToSpeech {
  late FlutterTts textToSpeech;
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  Future<void> speech(String text) async {
    textToSpeech = FlutterTts();
    double volume = 1;
    double pitch = 1;
    double rate = doubleInRange(0.45, 0.55);
    textToSpeech.getVoices.then((value) {
      if (value != null) {
        print(value);
        textToSpeech.setVoice(value[Random().nextInt(value.length)].cast<String, String>());
      }
      // textToSpeech.setLanguage("en-US");
      // if (isAndroid) {
      //   textToSpeech.isLanguageInstalled("en-US").then((value) => (value as bool));
      // }
      _speak(volume, rate, pitch, text);
    });
  }

  double doubleInRange(num start, num end) {
    return Random().nextDouble() * (end - start) + start;
  }

  Future<void> stop() async {
    _stop();
  }

  Future _getDefaultEngine() async {
    await textToSpeech.getDefaultEngine;
  }

  Future _getDefaultVoice() async {
    await textToSpeech.getDefaultVoice;
  }

  Future _speak(double volume, double rate, double pitch, String text) async {
    await textToSpeech.setVolume(volume);
    await textToSpeech.setSpeechRate(rate);
    await textToSpeech.setPitch(pitch);

    if (text.isNotEmpty) {
      await textToSpeech.speak(text);
    }
  }

  Future _setAwaitOptions() async {
    await textToSpeech.awaitSpeakCompletion(true);
  }

  initTts() {
    textToSpeech = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    textToSpeech.setStartHandler(() {});

    if (isAndroid) {
      textToSpeech.setInitHandler(() {});
    }

    textToSpeech.setCompletionHandler(() {
      _stop();
    });

    textToSpeech.setCancelHandler(() {
      _stop();
    });

    textToSpeech.setPauseHandler(() {});

    textToSpeech.setContinueHandler(() {});

    textToSpeech.setErrorHandler((msg) {
      _stop();
    });
  }

  Future _stop() async {
    await textToSpeech.stop();
  }
}

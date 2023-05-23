import 'dart:math';

import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter_tts/flutter_tts.dart';

class CommonTextToSpeech {
  static final CommonTextToSpeech _commonTextToSpeech = CommonTextToSpeech._internal();

  factory CommonTextToSpeech() {
    return _commonTextToSpeech;
  }

  CommonTextToSpeech._internal();

  late FlutterTts textToSpeech = FlutterTts();
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;
  static List<dynamic> voices = [];

  Future<void> speech(String text, {Function? completed}) async {
    textToSpeech.setCompletionHandler(() {
      if (completed != null) {
        completed();
      }
    });
    double volume = 1;
    double pitch = 1;
    double rate = doubleInRange(0.35, 0.45);
    if (voices.isEmpty) {
      textToSpeech.getVoices.then((value) {
        if (value != null) {
          for (var voice in value) {
            if (voice['locale'] == 'en-US') {
              voices.add(voice);
            }
          }
        }
        if (kDebugMode) {
          print(voices);
        }
        if (voices.isEmpty) {
          textToSpeech.setLanguage("en-US");
          if (isAndroid) {
            textToSpeech.isLanguageInstalled("en-US").then((value) => (value as bool));
          }
        } else {
          textToSpeech.setVoice(voices[Random().nextInt(voices.length)].cast<String, String>());
        }
        _speak(volume, rate, pitch, text);
      });
    } else {
      textToSpeech.setVoice(voices[Random().nextInt(voices.length)].cast<String, String>());
      _speak(volume, rate, pitch, text);
    }
  }

  double doubleInRange(num start, num end) {
    return Random().nextDouble() * (end - start) + start;
  }

  Future _speak(double volume, double rate, double pitch, String text) async {
    await textToSpeech.setVolume(volume);
    await textToSpeech.setSpeechRate(rate);
    await textToSpeech.setPitch(pitch);

    if (text.isNotEmpty) {
      await textToSpeech.speak(text);
    }
  }

  Future stop() async {
    await textToSpeech.stop();
  }

  // Future<void> stop() async {
  //   _stop();
  // }

  // Future _getDefaultEngine() async {
  //   await textToSpeech.getDefaultEngine;
  // }

  // Future _getDefaultVoice() async {
  //   await textToSpeech.getDefaultVoice;
  // }

  // Future _setAwaitOptions() async {
  //   await textToSpeech.awaitSpeakCompletion(true);
  // }

  // initTts() {
  //   textToSpeech = FlutterTts();

  //   _setAwaitOptions();

  //   if (isAndroid) {
  //     _getDefaultEngine();
  //     _getDefaultVoice();
  //   }

  //   textToSpeech.setStartHandler(() {});

  //   if (isAndroid) {
  //     textToSpeech.setInitHandler(() {});
  //   }

  //   textToSpeech.setCompletionHandler(() {
  //     _stop();
  //   });

  //   textToSpeech.setCancelHandler(() {
  //     _stop();
  //   });

  //   textToSpeech.setPauseHandler(() {});

  //   textToSpeech.setContinueHandler(() {});

  //   textToSpeech.setErrorHandler((msg) {
  //     _stop();
  //   });
  // }
}

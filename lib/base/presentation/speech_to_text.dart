import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:async';

class CommonSpeechToText {
  final SpeechToText _speechToText = SpeechToText();
  Future<void> listen({required Function(String) onListen, required Function() onStop}) async {
    await _speechToText.initialize(
      finalTimeout: const Duration(seconds: 5),
      onStatus: (val) {
        if (kDebugMode) {
          print('onStatus: $val');
        }
        if (val != 'listening' && val != 'notListening') {
          onStop.call();
          _speechToText.stop();
        }
      },
      onError: (val) {
        if (kDebugMode) {
          print('onStatus: $val');
        }
      },
    );
    _speechToText.listen(
      localeId: 'en_001',
      onResult: (val) => {
        onListen(val.recognizedWords),
      },
    );
  }

  Future<void> stop() async {
    await _speechToText.stop();
  }
}

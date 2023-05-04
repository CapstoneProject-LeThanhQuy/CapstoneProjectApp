import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:async';

class CommonSpeechToText {
  Future<void> listen(Function(String) onListen) async {
    SpeechToText speech = SpeechToText();
    await speech.initialize(
      onStatus: (val) {
        if (kDebugMode) {
          print('onStatus: $val');
        }
        if (val == 'done') {
          speech.stop();
        }
      },
      onError: (val) {
        if (kDebugMode) {
          print('onStatus: $val');
        }
      },
    );
    speech.listen(
      localeId: 'en_001',
      onResult: (val) => {
        onListen(val.recognizedWords),
      },
    );
  }
}

import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceService {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  Function()? onSOSDetected;

  VoiceService({this.onSOSDetected}) {
    _speech = stt.SpeechToText();
  }

  Future<bool> initSpeech() async {
    return await _speech.initialize();
  }

  void startListening() async {
    if (!_isListening) {
      bool available = await initSpeech();
      if (!available) return;

      _speech.listen(
        onResult: (result) {
          String recognized = result.recognizedWords.toLowerCase();
          print('Recognized: \$recognized');
          if (recognized.contains('help me')) {
            if (onSOSDetected != null) onSOSDetected!();
            stopListening();
          }
        },
        listenFor: Duration(seconds: 10),
        pauseFor: Duration(seconds: 3),
        partialResults: true,
        localeId: 'en_US',
      );
      _isListening = true;
    }
  }

  void stopListening() {
    if (_isListening) {
      _speech.stop();
      _isListening = false;
    }
  }
}

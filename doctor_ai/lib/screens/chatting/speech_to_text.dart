import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechToText {
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _recognizedText = '';
  bool _isListening = false;
  bool _isAvailable = false;
  Timer? _timer;

  String get recognizedText => _recognizedText;
  bool get isListening => _isListening;

  Future<void> initialize() async {
    _isAvailable = await _speech.initialize(
      onStatus: (status) {
        print('Status: $status');
        if (status == "listening") {
          _isListening = true;
        } else if (status == "notListening") {
          _isListening = false;
        } else {
          _isListening = false;
        }
      },
      onError: (error) {
        print('Error: $error');
        _isListening = false;
      },
    );

    if (!_isAvailable) {
      print('The user has denied the use of speech recognition.');
    }
  }

  void startListening(void Function(String) onResult) {
    if (_isAvailable && !_isListening) {
      _speech.listen(
        onResult: (result) {
          _recognizedText = result.recognizedWords;
          onResult(_recognizedText);
        },
        listenFor: const Duration(seconds: 7), // Increase or decrease as needed
      );

      _startListeningTimer();
    }
  }

  void _startListeningTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
    _timer = Timer(const Duration(seconds: 10), () {
      if (_isListening) {
        stopListening();
      }
    });
  }

  void stopListening() {
    if (_isListening) {
      _speech.stop();
      _isListening = false;
      if (_timer != null && _timer!.isActive) {
        _timer!.cancel();
      }
    }
  }
}

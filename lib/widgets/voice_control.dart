import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechButton extends StatefulWidget {
  final Function(String)? onSpeechResult;

  const SpeechButton({Key? key, this.onSpeechResult}) : super(key: key);

  @override
  _SpeechButtonState createState() => _SpeechButtonState();
}

class _SpeechButtonState extends State<SpeechButton> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String text = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AvatarGlow(
        animate: _isListening,
        glowColor: _isListening ? Colors.blue : Colors.white,
        duration: const Duration(milliseconds: 2000),
        startDelay: const Duration(milliseconds: 100),
        glowRadiusFactor: 0.5,
        repeat: true,
        child: TextButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              text = val.recognizedWords;
            });
            if (widget.onSpeechResult != null) {
              widget.onSpeechResult!(text); // Invoke the callback
            }
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}

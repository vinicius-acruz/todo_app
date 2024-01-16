import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceControl extends StatefulWidget {
  @override
  _VoiceControlState createState() => _VoiceControlState();
}

class _VoiceControlState extends State<VoiceControl> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    print('got pressed');
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print(_text);
            // TODO: Interpret and act on recognized words
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.blue, // Change the background color as needed
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              30), // Adjust the border radius for rounded edges
        ),
        shadowColor: Colors.black, // Shadow color
        elevation: 5, // Shadow elevation
      ),
      onPressed: _listen,
      child: Icon(
        _isListening ? Icons.mic : Icons.mic_none,
        color: Colors.white, // Change the icon color as needed
      ),
    );
  }
}

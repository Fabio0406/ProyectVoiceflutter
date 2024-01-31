import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:text_to_speech/text_to_speech.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: VoiceHome(),
    );
  }
}

class VoiceHome extends StatefulWidget {
  @override
  _VoiceHomeState createState() => _VoiceHomeState();
}

class _VoiceHomeState extends State<VoiceHome> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tarea IHC'),
        backgroundColor: Color.fromRGBO(0, 50, 100, 0.747),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        onPressed: _listen,
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          color: Color.fromRGBO(1, 1, 1, 0.13),
          child: Text(_text),
        ),
      ),
    );
  }

  void _listen() async {
    TextToSpeech tts = TextToSpeech();  
    tts.setLanguage('es-MX');
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
            
          }), localeId:'es-MX' 
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
      tts.speak(_text);
    }
  }
}







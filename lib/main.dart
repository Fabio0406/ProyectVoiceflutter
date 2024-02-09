// ignore_for_file: deprecated_member_use

import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';

import 'app_body.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BURGER',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'BURGER'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DialogFlowtter dialogFlowtter;

  late stt.SpeechToText _speech;
  String _text = '';
  bool _isListening = false;

  List<Map<String, dynamic>> mensajes = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Burger',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(96, 233, 204, 77),
        leading: IconButton(
          icon: const Icon(
            Icons.fastfood,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          Expanded(child: AppBody(mensajes: mensajes)),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            color: const Color.fromARGB(157, 129, 5, 5),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _text,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _listen();
                  },
                  icon: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: const Color.fromRGBO(255, 255, 255, 1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void enviarmensajes(String text) async {
    if (text.isEmpty) return;
    setState(() {
      addmensajes(
        Message(text: DialogText(text: [text])),
        true,
      );
    });

    DetectIntentResponse response = await dialogFlowtter.detectIntent(
      queryInput: QueryInput(text: TextInput(text: text)),
    );
    FlutterTts flutterTts = FlutterTts();
    flutterTts.setLanguage('es-MX');

  // Establece el manejador de finalización
  flutterTts.setCompletionHandler(() {
    _listen(); // Activa el micrófono después de que el bot termine de hablar
  });

  flutterTts.speak(response.text as String);
    if (response.message == null) return;
    setState(() {
      addmensajes(response.message!);
    });
  }

  void addmensajes(Message message, [bool isUserMessage = false]) {
    mensajes.add({
      'message': message,
      'isUserMessage': isUserMessage,
    });
  }

 void _listen() async {
  if (!_isListening) {
    bool available = await _speech.initialize(
      onStatus: (val) {
        print('Estado del reconocimiento de voz: $val'); // Imprime el estado actual
        if (val == 'done') {
          setState(() => {_isListening = false,
          _speech.stop(),
          enviarmensajes(_text),          
          _text = ''            
          });
        }
      },
      // ignore: avoid_print
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      setState(() => _isListening = true);
      print('Escuchando...'); // Imprime cuando comienza a escuchar
      _speech.listen(
        onResult: (val) => setState(() {
          _text = val.recognizedWords;
        }),
        localeId: 'es-MX',
        // comentar esta seccion si se va correr en celular
        // listenFor: const Duration(seconds: 60),
        //   pauseFor: const Duration(seconds: 10),
        //   partialResults: true,
        //   onDevice: true,
        //   listenMode: stt.ListenMode.confirmation,
        // hasta aca
      );
    }
  } else {
    setState(() => _isListening = false);
    print('Dejó de escuchar'); // Imprime cuando deja de escuchar
    _speech.stop();
  }
}
  @override
  void dispose() {
    dialogFlowtter.dispose();
    super.dispose();
  }
}

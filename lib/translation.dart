/*import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';
class translationPage extends StatefulWidget {
  @override
  State<translationPage> createState() => _translationPageState();
}

class _translationPageState extends State<translationPage> {
  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
        onTap: () => print('flutter'),
        textStyle: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        )),
    'voice': HighlightedWord(
        onTap: () => print('voice'),
        textStyle: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        )),
    'subscribe': HighlightedWord(
      onTap: () => print('subscribe'),
      textStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
    ),
    'like': HighlightedWord(
      onTap: () => print('like'),
      textStyle: const TextStyle(
        color: Colors.blueAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
    'comment': HighlightedWord(
      onTap: () => print('comment'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
  stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Confidence'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        //endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        //repeatPauseDirection: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: () {},
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: TextHighlight(
            text: _text,
            words:_highlights,
            textStyle :TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            )
          ),
        ),
      ),
    );
  }
};

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 74, 195, 222),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: const Column(
            children: [
              SizedBox(height: 60),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 30),
                title: Text(
                  "Speak Freely,Understand Instantly!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Container(
          margin: EdgeInsets.only(left: 10, right: 210),
          height: 50,
          width: 60,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 74, 195, 222),
            borderRadius: const BorderRadius.only(
                //bottomLeft: Radius.circular(0),
                //bottomRight: Radius.circular(50),
                ),
          ),
        )
      ],
    ));
  }*/

*/

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';

class Translation extends StatefulWidget {
  const Translation({super.key});

  @override
  State<Translation> createState() => _TranslationState();
}

class _TranslationState extends State<Translation> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button to speak';
  String _translatedText = 'Translation will appear here';
  final translator = GoogleTranslator();

  String inputLanguage = 'en';
  String outputLanguage = 'ta';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _text = result
                .recognizedWords; // Update the text as speech is recognized
          });
        },
      );
    } else {
      print("Speech recognition not available");
    }
  }

  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  Future<void> _translateText() async {
    if (_text.isNotEmpty) {
      final translation = await translator.translate(
        _text,
        from: inputLanguage,
        to: outputLanguage,
      );
      setState(() {
        _translatedText = translation.text; // Update the translated text
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Translation'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  "android/assets/voice5.jpg",
                  fit: BoxFit.contain,
                  height: 250,
                ),
                SizedBox(height: 16),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    prefixIcon: IconButton(
                      padding: EdgeInsets.symmetric(
                          vertical: 50.0, horizontal: 50.5),
                      icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
                      onPressed:
                          _isListening ? _stopListening : _startListening,
                    ),
                    border: OutlineInputBorder(),
                    hintText: "Speak or type text to translate....",
                  ),
                  controller: TextEditingController(text: _text),
                  onChanged: (value) {
                    setState(() {
                      _text = value;
                    });
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButton<String>(
                      value: inputLanguage,
                      onChanged: (newValue) {
                        setState(() {
                          inputLanguage = newValue!;
                        });
                      },
                      items: <String>[
                        'en',
                        'ta',
                        'hi',
                        'te',
                        'kn',
                        'ml',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    Icon(Icons.arrow_forward_rounded),
                    DropdownButton<String>(
                      value: outputLanguage,
                      onChanged: (newValue) {
                        setState(() {
                          outputLanguage = newValue!;
                        });
                      },
                      items: <String>[
                        'en',
                        'ta',
                        'hi',
                        'te',
                        'kn',
                        'ml',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _translateText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    minimumSize: Size.fromHeight(55),
                  ),
                  child: Text("Translate"),
                ),
                SizedBox(height: 30),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Translation will appear here...",
                  ),
                  controller: TextEditingController(text: _translatedText),
                  readOnly: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

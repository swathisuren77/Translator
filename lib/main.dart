import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:women_financial/translation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemini AI Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GeminiChatScreen(),
    );
  }
}

class GeminiChatScreen extends StatefulWidget {
  @override
  _GeminiChatScreenState createState() => _GeminiChatScreenState();
}

class _GeminiChatScreenState extends State<GeminiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  String _responseText = "Response will appear here...";
  bool _isLoading = false;

  // Replace with your Gemini API key
  static const String apiKey = "AIzaSyBaMf_SOk0HM1npOkY5CQtmqb9F4Kzp1nc";
  static const String apiUrl =
      "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey";

  Future<void> generateText(String prompt) async {
    setState(() {
      _isLoading = true;
      _responseText = "Generating response...";
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String generatedText =
            data["candidates"][0]["content"]["parts"][0]["text"];

        setState(() {
          _responseText = generatedText;
        });
      } else {
        setState(() {
          _responseText = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _responseText = "Failed to generate response.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gemini AI Chat"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.translate),
            onPressed: () {
              // Navigate to the TranslationPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Translation()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Enter your prompt",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      String inputText = _controller.text.trim();
                      if (inputText.isNotEmpty) {
                        generateText(inputText);
                      }
                    },
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text("Generate Response"),
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _responseText,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:women_financial/translation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Voice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpeechScreen(),
    );
  }
}

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final Map<String, HighlightedWord> _highlights = {
    'flutter': HighlightedWord(
      onTap: () => print('flutter'),
      textStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
      ),
    ),
    'voice': HighlightedWord(
      onTap: () => print('voice'),
      textStyle: const TextStyle(
        color: Colors.green,
        fontWeight: FontWeight.bold,
      ),
    ),
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
  };

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button to speak';
  FontStyle _textStyle = FontStyle.italic;
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
        title: Text('EduTrans'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.translate),
            onPressed: () {
              // Navigate to the TranslationPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Translation()),
              );
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        //endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        //repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      /*body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("android/assets/voice5.jpg"),
            fit: BoxFit.cover,
          ),
        ),*/
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          margin: EdgeInsets.only(top: 100),
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: TextHighlight(
            text: _text,
            words: _highlights,
            textStyle: const TextStyle(
              fontSize: 32.0,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
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
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }
}*/



  //final List<String> titleList = ["Woman", "calculator"];
  



    /* body: ListView(
        padding: EdgeInsets.zero,
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
                    "EduTrans",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],

              /*title: Text(
          "FemFinance",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.end,
        ),
        backgroundColor: Colors.pink[300],*/

              /*body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Text(
            // 'You have pushed the button this many times:',
            //   ),
          ],
        ),
      ),*/
            ),
          ),
          /* SizedBox(
            height: 50,
          ),
          SizedBox(
            height: 30,
            child: Text(
              "Speech To Text",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(1),
            alignment: Alignment.bottomCenter,
            height: 300,
            decoration: BoxDecoration(
              // color: Colors.pink[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 300,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    image: DecorationImage(
                      image: AssetImage(
                        "android/assets/mic4s.png",
                      ),
                      //fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),*/
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 100,
            child: Text(
              "Speech To Text ,\nClick the below button to Speak",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Container(

              //margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                // borderRadius: BorderRadius.circular(30),
                /*boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      spreadRadius: 5,
                      blurRadius: 6,
                    )
                  ]*/
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => translationPage()));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 500,
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          alignment: Alignment.bottomCenter,

                          image: AssetImage(
                            "android/assets/mic.jpg",
                          ),

                          //  fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    /*Container(
                      height: 150,
                      margin: EdgeInsets.only(bottom: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        image: DecorationImage(
                          alignment: Alignment.center,
                          image: AssetImage(
                            "android/assets/trans.jpg",
                          ),

                          //  fit: BoxFit.cover,
                        ),
                      ),
                    ),*/
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
*/
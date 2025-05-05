import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class AudioToTextScreen extends StatefulWidget {
  @override
  _AudioToTextScreenState createState() => _AudioToTextScreenState();
}

class _AudioToTextScreenState extends State<AudioToTextScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  TextEditingController _textController = TextEditingController();
  late Timer _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          _seconds = 0;
        });
        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            _seconds++;
          });
        });
        _speech.listen(
          onResult: (result) {
            setState(() {
              _textController.text = result.recognizedWords;
            });
          },
          listenFor: Duration(seconds: 999999),
          pauseFor: Duration(seconds: 10),
          partialResults: true,
        );
      } else {
        print("Speech recognition not available");
      }
    } else {
      print("Microphone permission denied");
    }
  }

  void _stopListening() async {
    setState(() => _isListening = false);
    _speech.stop();
    _timer.cancel();
  }

  void _copyText() {
    Clipboard.setData(ClipboardData(text: _textController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Copied to clipboard")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio to Text"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: TextField(
                  controller: _textController,
                  maxLines: null,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: "Transcribed text will appear here...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Recording Time: ${_seconds}s',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.copy),
                  onPressed: _copyText,
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isListening ? null : _startListening,
                  child: Text("Start"),
                ),
                ElevatedButton(
                  onPressed: _isListening ? _stopListening : null,
                  child: Text("Stop"),
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}
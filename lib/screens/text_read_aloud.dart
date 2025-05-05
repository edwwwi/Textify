import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextReadAloudScreen extends StatefulWidget {
  @override
  _TextReadAloudScreenState createState() => _TextReadAloudScreenState();
}

class _TextReadAloudScreenState extends State<TextReadAloudScreen> {
  FlutterTts flutterTts = FlutterTts();
  String fileContent = "No file selected.";
  TextEditingController textController = TextEditingController();

  Future<void> pickAndReadFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      String content = await file.readAsString();

      setState(() {
        fileContent = content;
        textController.text = content;
      });

      await flutterTts.speak(content);
    }
  }

  Future<void> speakText() async {
    await flutterTts.speak(textController.text);
  }

  Future<void> pauseSpeech() async {
    await flutterTts.pause();
  }

  Future<void> stopSpeech() async {
    await flutterTts.stop();
  }

  Future<void> resumeSpeech() async {
    await flutterTts.speak(textController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Read Aloud App")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: pickAndReadFile,
              child: Text("Pick and Read TXT File"),
            ),
            SizedBox(height: 20),
            TextField(
              controller: textController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Type or edit text here...",
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.play_arrow, size: 30),
                  onPressed: speakText,
                  tooltip: "Play",
                ),
                IconButton(
                  icon: Icon(Icons.pause, size: 30),
                  onPressed: pauseSpeech,
                  tooltip: "Pause",
                ),
                IconButton(
                  icon: Icon(Icons.stop, size: 30),
                  onPressed: stopSpeech,
                  tooltip: "Stop",
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  fileContent,
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
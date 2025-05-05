import 'package:flutter/material.dart';
import 'screens/audio_to_text.dart';
import 'screens/image_to_text.dart';
import 'screens/text_read_aloud.dart';
import 'screens/youtube_caption.dart';
import 'home_screen.dart';

void main() {
  runApp(TextifyApp());
}

class TextifyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Textify',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

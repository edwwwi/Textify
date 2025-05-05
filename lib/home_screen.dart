import 'package:flutter/material.dart';
import 'screens/audio_to_text.dart';
import 'screens/image_to_text.dart';
import 'screens/text_read_aloud.dart';
import 'screens/youtube_caption.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Textify Home")),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.all(16),
        children: [
          CustomButton(title: "Audio to Text", icon: Icons.mic, screen: AudioToTextScreen()),
          CustomButton(title: "Text Read Aloud", icon: Icons.volume_up, screen: TextReadAloudScreen()),
          CustomButton(title: "Image to Text (OCR)", icon: Icons.camera, screen: ImageToTextScreen()),
          CustomButton(title: "YouTube Captions", icon: Icons.subtitles, screen: YouTubeCaptionScreen()),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget screen;

  CustomButton({required this.title, required this.icon, required this.screen});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50),
            SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

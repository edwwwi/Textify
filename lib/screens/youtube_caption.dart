import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class YouTubeCaptionScreen extends StatefulWidget {
  const YouTubeCaptionScreen({super.key});

  @override
  _YouTubeCaptionScreenState createState() => _YouTubeCaptionScreenState();
}

class _YouTubeCaptionScreenState extends State<YouTubeCaptionScreen> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _subtitleController = TextEditingController();
  bool _isLoading = false;

  Future<void> _extractSubtitles() async {
    setState(() {
      _isLoading = true;
      _subtitleController.clear();
    });

      const String apiUrl = "http://192.168.235.51:5000/get_subtitles";


    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"url": _urlController.text}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _subtitleController.text = responseData["subtitles"] ?? "No subtitles found.";
        });
      } else {
        setState(() {
          _subtitleController.text = "Error: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        _subtitleController.text = "Failed to connect to server.\nError: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _copySubtitles() {
    if (_subtitleController.text.isEmpty) return;
    
    Clipboard.setData(ClipboardData(text: _subtitleController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Subtitles copied to clipboard!"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _clearSubtitles() {
    setState(() {
      _subtitleController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('YouTube Subtitle Extractor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: 'YouTube URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _extractSubtitles,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Get Subtitles'),
                ),
                ElevatedButton.icon(
                  onPressed: _subtitleController.text.isEmpty ? null : _copySubtitles,
                  icon: const Icon(Icons.copy, size: 20),
                  label: const Text('Copy'),
                ),
                ElevatedButton.icon(
                  onPressed: _subtitleController.text.isEmpty ? null : _clearSubtitles,
                  icon: const Icon(Icons.clear, size: 20),
                  label: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _subtitleController,
                    maxLines: null,
                    expands: true,
                    decoration: const InputDecoration(
                      hintText: 'Subtitles will appear here...',
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
from flask import Flask, request, jsonify
from flask_cors import CORS
import re
from youtube_transcript_api import YouTubeTranscriptApi

app = Flask(__name__)
CORS(app)  # Allow cross-origin requests

@app.route('/get_subtitles', methods=['POST'])
def get_subtitles():
    print("Received a request!")  # Debugging log
    data = request.get_json()
    video_url = data.get('url')

    if not video_url:
        return jsonify({"error": "No URL provided"}), 400

    try:
        print(f"Processing video URL: {video_url}")  # Debugging log
        
        # Extract YouTube Video ID from various URL formats
        video_id_match = re.search(r"(?:v=|\/|youtu\.be\/)([0-9A-Za-z_-]{11})", video_url)
        video_id = video_id_match.group(1) if video_id_match else None

        if not video_id:
            return jsonify({"error": "Invalid YouTube URL"}), 400

        # Fetch transcript
        transcript = YouTubeTranscriptApi.get_transcript(video_id)
        subtitles = "\n".join([item["text"] for item in transcript])

        print("Subtitles fetched successfully!")  # Debugging log
        return jsonify({"subtitles": subtitles})

    except Exception as e:
        print(f"Error: {str(e)}")  # Debugging log
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    print("Starting Flask server...")  # Debugging log
    app.run(host='0.0.0.0', port=5000, debug=True)

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? _imageFile;
  Uint8List? _imageBytes;
  String? _recognizedText;
  bool _loading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _imageBytes = bytes;
          _imageFile = null;
        });
      } else {
        setState(() {
          _imageFile = File(picked.path);
          _imageBytes = null;
        });
      }
    }
  }

  Future<void> _uploadImage() async {
    setState(() {
      _loading = true;
      _recognizedText = null;
    });

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:8000/predict'), // Use your LAN IP for real devices
    );

    try {
      if (kIsWeb && _imageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'file',
          _imageBytes!,
          filename: 'upload.jpg',
        ));
      } else if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          _imageFile!.path,
        ));
      } else {
        throw Exception('No image selected');
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        final res = await http.Response.fromStream(response);
        final jsonData = json.decode(res.body);
        setState(() => _recognizedText = jsonData['text']);
      } else {
        setState(() => _recognizedText = 'Failed with status ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _recognizedText = 'Error: $e');
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Handwriting Recognition")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.photo),
              label: const Text("Pick Image"),
              onPressed: _pickImage,
            ),
            const SizedBox(height: 16),
            if (_imageBytes != null)
              Image.memory(_imageBytes!, height: 200)
            else if (_imageFile != null)
              Image.file(_imageFile!, height: 200),
            const SizedBox(height: 16),
            if (_imageBytes != null || _imageFile != null)
              ElevatedButton.icon(
                icon: const Icon(Icons.upload),
                label: const Text("Upload & Recognize"),
                onPressed: _uploadImage,
              ),
            const SizedBox(height: 20),
            if (_loading) const CircularProgressIndicator(),
            if (_recognizedText != null) ...[
              const SizedBox(height: 12),
              const Text("Recognized Text:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          _recognizedText!,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
            ]
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DreamImageGenerator extends StatefulWidget {
  const DreamImageGenerator({super.key});

  @override
  DreamImageGeneratorState createState() => DreamImageGeneratorState();
}

class DreamImageGeneratorState extends State<DreamImageGenerator> {
  String imageUrl = '';

  Future<void> generateImage(String prompt) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/prompt'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'prompt': prompt}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        imageUrl = data['image_url'];
      });
    } else {
      throw Exception('Failed to generate image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dream Image Generator')),
      body: Column(
        children: [
          TextField(
            onSubmitted: (value) {
              generateImage(value);
            },
            decoration: InputDecoration(labelText: 'Enter your dream description'),
          ),
          if (imageUrl.isNotEmpty)
            Image.network(imageUrl),
        ],
      ),
    );
  }
}
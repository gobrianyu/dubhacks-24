import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

// View for a single journal entry. Includes editable title and text fields.
class DiaryEntry extends StatefulWidget {
  const DiaryEntry({super.key});

  @override
  State<DiaryEntry> createState() => _DiaryEntryState();
}

// State for EntryView
class _DiaryEntryState extends State<DiaryEntry> {
  String currentText = ''; // Text field that we update.
  String currentName = ''; // Title/name field that we update.
  String imageUrl = ''; // URL of the generated image.

  @override
  Widget build(BuildContext context) {
    Color textColour = const Color.fromARGB(255, 84, 66, 61);
    Color secondaryTextColour = const Color.fromARGB(150, 84, 66, 61);

    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          initialValue: currentName,
          style: TextStyle(fontWeight: FontWeight.bold, color: textColour, fontSize: 20),
          decoration: InputDecoration(
            hintText: 'Title',
            hintStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: secondaryTextColour,
              fontSize: 20,
            ),
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColour,
              fontSize: 20,
            ),
          ),
          onChanged: (name) => setState(() => currentName = name),
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextFormField(
              autofocus: true,
              initialValue: currentText,
              expands: true,
              maxLines: null,
              decoration: const InputDecoration(border: InputBorder.none),
              onChanged: (text) => setState(() => currentText = text),
            ),
          ),
          IconButton(
            icon: Icon(Icons.pending),
            onPressed: () {
              generateImage(currentText);
            },
          ),
          if (imageUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(15),
              child: Image.network(imageUrl), // Display the generated image
            ),
        ],
      ),
    );
  }

  void generateImage(String prompt) async {
    if (prompt.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a prompt to generate an image.')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/prompt'), // Update with your Flask server URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'prompt': prompt}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          imageUrl = data['image']; // Set the URL of the generated image
        });
      } else {
        throw Exception('Failed to generate image');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating image.')),
      );
    }
  }
}
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';


// View for a single journal entry. Includes
// editable title and text fields.
class DiaryEntry extends StatefulWidget {

  const DiaryEntry({super.key});

  @override
  State<DiaryEntry> createState() => _DiaryEntryState();
}


// State for EntryView
class _DiaryEntryState extends State<DiaryEntry>{
  String currentText = ''; // Text field that we update.
  String currentName = ''; // Title/name field that we update.
  String imageUrl = '';


  // Initialises state to have currentText be original entry text,
  // and the same for name.
  @override
  void initState() {
    super.initState();
  }


  // Building the view.
  @override
  Widget build(BuildContext context) {
    Color textColour = const Color.fromARGB(255, 84, 66, 61); // Primary text colour for light mode.
    Color secondaryTextColour = const Color.fromARGB(150, 84, 66, 61); // Secondary text colour for light mode.
    
    return Scaffold(

        // Editable title text field.
        appBar: AppBar(
          title: TextFormField(
            initialValue: currentName,
            style: TextStyle(fontWeight: FontWeight.bold, color: textColour, fontSize: 20),
            decoration: InputDecoration(
              hintText: 'Title', 
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: secondaryTextColour,
                fontSize: 20
              ),
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColour,
                fontSize: 20
              ),
            ),
            onChanged: (name) => {currentName = name},
          ),
        ),

        // Main editable text field body.
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
                    onChanged: (text) => {currentText = text},
                  ),
                ),
            IconButton(
              icon: Icon(Icons.pending),
              onPressed: () {
                generateImage(currentText);
              },
            ),
            imageUrl.isNotEmpty ? 
              Padding(
                padding: const EdgeInsets.all(15),
                child: Image.network(imageUrl), // Display the generated image
              ) : const SizedBox()
          ],
        ),          
      );
  }

  Future<void> generateImage(String prompt) async {
    print('debug: waiting');
    final String apiKey = const String.fromEnvironment('OPEN_API_KEY');
    final String apiUrl = 'https://api.openai.com/v1/images/generations';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': "dall-e-3",
        'prompt': prompt,
        'n': 1, // Number of images to generate
        'size': '1024x1024', // Image size
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('${responseData['data'][0]['url']}');
      setState(() {
        imageUrl = '${responseData['data'][0]['url']}';
      });
    } else {
      print('Error: ${response.statusCode} ${response.body}');
    }
  }
}
import 'package:hive/hive.dart';
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
  String imageUrl = '';
  String imageCaption = '';
  final Color backColour = Color.fromARGB(255, 26, 2, 37);
  final Color accentColour = Color.fromARGB(255, 149, 49, 109);
  final Color textColour = Colors.white;


  // Initialises state to have currentText be original entry text,
  // and the same for name.
  @override
  void initState() {
    super.initState();
  }


  // Building the view.
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomCenter,
          colors: [
            accentColour,
            backColour
          ],
        )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
          // Editable title text field.
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white), // Custom back button icon
              onPressed: () {
                Navigator.pop(context); // Manually control the back navigation
              },
            ),
            backgroundColor: Colors.transparent,
            title: Text(getDate(DateTime.now()), style: TextStyle(color: textColour, fontWeight: FontWeight.w500),)
          ),
      
          // Main editable text field body.
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    autofocus: true,
                    initialValue: currentText,
                    expands: true,
                    maxLines: null,
                    decoration: const InputDecoration(border: InputBorder.none),
                    onChanged: (text) => {currentText = text},
                    style: TextStyle(color: textColour),
                    cursorColor: Colors.white
                  ),
                ),
              ),
              imageUrl.isNotEmpty
                ? Padding(
                  padding: const EdgeInsets.all(15),
                  child: Image.network(imageUrl), // Display the generated image
                ) 
                : const SizedBox(),
              GestureDetector(
                onTap: () {
                  if (currentText.trim() != '') {
                    generateImage(currentText);
                  }
                },                
                child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                  decoration: BoxDecoration(
                    color: textColour,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text(imageUrl.isNotEmpty ? 'Regenerate Image' : 'Generate Image with DALL-E 3', style: TextStyle(fontWeight: FontWeight.bold, color: backColour))
                ),
              ),
              SizedBox(height: 30)
            ],
          ),          
        ),
    );
  }

  Future<void> generateImage(String prompt) async {
    print('debug: waiting');
    const String apiKey = String.fromEnvironment('OPENAI_API_KEY');
    print(apiKey);
    const String apiUrl = 'https://api.openai.com/v1/images/generations';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': "dall-e-3",
        'prompt': "Create an image in a photo-realistic format from the perspective of someone dreaming this dream:$prompt. Make sure to be as loyal to the source dream as possible.",
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

  Future<void> generateCaption(String prompt) async {
    const String apiKey = String.fromEnvironment('OPENAI_API_KEY');
    const String apiUrl = 'https://api.openai.com/v1/chat/completions';

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': "gpt-4",
        'messages': [
          {'role': "system", 'content': "You are a helpful assistant."},
          {
            'role': "user",
            'content': "Create a 1 sentence caption of this description of a dream: $prompt",
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      setState(() {
        imageCaption = '${responseData['choices'][0]['message']['content']}';
      });
    } else {
      throw Exception('Failed to generate caption: ${response.statusCode} ${response.body}');
    }
  }
}

String monthAsAbbrevString(int month) {
  switch (month) {
    case 1: return 'Jan';
    case 2: return 'Feb';
    case 3: return 'Mar';
    case 4: return 'Apr';
    case 5: return 'May';
    case 6: return 'June';
    case 7: return 'July';
    case 8: return 'Aug';
    case 9: return 'Sep';
    case 10: return 'Oct';
    case 11: return 'Nov';
    case 12: return 'Dec';
    default: return '???';
  }
}

String getDate(DateTime time) {
  return '${monthAsAbbrevString(time.month)} ${time.day}, ${time.year}';
}
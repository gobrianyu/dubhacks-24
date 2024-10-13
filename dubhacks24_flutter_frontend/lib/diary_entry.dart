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
          title: Text(getDate(DateTime.now()))
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
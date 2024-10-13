import 'package:dubhacks24_flutter_frontend/account_provider.dart';
import 'package:dubhacks24_flutter_frontend/post.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// View for a single journal entry. Includes
// editable title and text fields.
class DiaryEntry extends StatefulWidget {

  const DiaryEntry({super.key});

  @override
  State<DiaryEntry> createState() => _DiaryEntryState();
}


// State for EntryView
class _DiaryEntryState extends State<DiaryEntry>{
  final TextEditingController _textController = TextEditingController();
  String currentText = ''; // Text field that we update.
  String imageUrl = '';
  final Color backColour = Color.fromARGB(255, 26, 2, 37);
  final Color accentColour = Color.fromARGB(255, 149, 49, 109);
  final Color textColour = Colors.white;
  bool loadLock = false;
  bool perplexLock = false;
  late final AccountProvider accProvider;


  // Initialises state to have currentText be original entry text,
  // and the same for name.
  @override
  void initState() {
    super.initState();
    accProvider = context.read<AccountProvider>();
  }


  // Building the view.
  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(
      builder: (context, accountProvider, _) {
        return Stack(
          children: [
            Container(
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
                            expands: true,
                            controller: _textController,
                            maxLength: 500,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (currentText.trim() != '') {
                                setState(() {
                                  loadLock = true;
                                  imageUrl = '';
                                });
                                await generateImage(currentText);
                                setState(() => loadLock = false);
                              }
                            },                
                            child: Container(
                              padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                              decoration: BoxDecoration(
                                color: textColour,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Text(loadLock ? 'Generating...' : imageUrl.isNotEmpty ? 'Regenerate Image' : 'Generate Image with DALL-E 3', style: TextStyle(fontWeight: FontWeight.bold, color: backColour))
                            ),
                          ),
                          imageUrl.isNotEmpty ? GestureDetector(
                            onTap: () async {
                              if (currentText.trim() != '') {
                                accProvider.addPost(DreamPost(
                                  username: accProvider.username, 
                                  imageLink: '', 
                                  time: DateTime.now(), 
                                  profilePic: accProvider.pfp, 
                                  caption: currentText)
                                );
                              }
                              Navigator.pop(context);
                            },                
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                              decoration: BoxDecoration(
                                color: textColour,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Text('Post!', style: TextStyle(fontWeight: FontWeight.bold, color: backColour))
                            ),
                          ) : SizedBox(),
                        ],
                      ),
                      SizedBox(height: 12),
                      GestureDetector(
                        onTap: () async {
                          if (currentText.trim() != '') {
                            setState(() {
                              perplexLock = true;
                            });
                            String? newText = await _summarizePrompt(currentText);
                            print('debug: $newText');
                            if (newText != null) {
                              setState(() => _textController.text = newText);
                            }
                            setState(() => perplexLock = false);
                          }
                        },                
                        child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
                          decoration: BoxDecoration(
                            color: textColour,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Text(perplexLock ? 'Generating...' : 'Enhance Text with Perplexity', style: TextStyle(fontWeight: FontWeight.bold, color: backColour))
                        ),
                      ),
                      SizedBox(height: 30)
                    ],
                  ),          
                ),
            ),
            loadLock || perplexLock ? SizedBox.expand(
              child: Container(
                color: const Color.fromARGB(100, 255, 255, 255),
                child: Center(child: CircularProgressIndicator(
                  color: Colors.purple
                ))
              ),
            ) : const SizedBox()
          ],
        );
      }
    );
  }

  Future<String?> _summarizePrompt(String prompt) async {
    const String apiKey = "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";
    const String baseUrl = "https://api.perplexity.ai";
    const String endpoint = "/chat/completions";
    
    final String finalPrompt = "Summarize this paragraph into 1 sentence: $prompt";

    final Map<String, dynamic> requestBody = {
      "model": "llama-3.1-sonar-small-128k-chat",
      "messages": [
        {
          "role": "system",
          "content": "You are an artificial intelligence assistant and you need to engage in a helpful, detailed, polite conversation with a user."
        },
        {
          "role": "user",
          "content": finalPrompt
        }
      ]
    };

    try {
      final response = await http.post(
        Uri.parse(baseUrl + endpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['choices'][0]['message']['content'];
      } else {
        throw Exception();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error enhancing text: $e')),
      );
      return null;
    }
  }

  Future<void> generateImage(String prompt) async {
    const String apiKey = String.fromEnvironment('OPENAI_API_KEY');
    const String apiUrl = 'https://api.openai.com/v1/images/generations';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': "dall-e-3",
          'prompt': "Create an image in a photo-realistic format from the perspective of someone dreaming this dream: $prompt. Make sure to be as loyal to the source dream as possible.",
          'n': 1, // Number of images to generate
          'size': '1024x1024', // Image size
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('${responseData['data'][0]['url']}'); // debugging print line
        setState(() {
          imageUrl = '${responseData['data'][0]['url']}';
        });
      } else {
        print('Error: ${response.statusCode} ${response.body}');
        throw Exception('${response.statusCode} failed response');
        // Handle different status codes or show a message to the user
      }
    } catch (e) {
      print('An error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating image: $e')),
      );
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
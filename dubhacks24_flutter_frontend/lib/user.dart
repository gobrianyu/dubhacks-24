import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {

  const UserPage ({super.key});

  @override
  State<UserPage> createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _profileInfo(),
            _photoGrid(),

          ],
        ),
      ),
    );
  }

  Widget _photoGrid() {
    return Expanded( // Wrap with Expanded
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        children: List.generate(21, (index) => _gridTile('image')),
      ),
    );
  }

  Widget _gridTile(String str) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black54,
          width: 0.3,
        ),
      ),
      child: Center(
        child: Text(
          str, // Use str instead of 'image' for flexibility
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _profileInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0), // Add some space above
      child: Row(
        children: [
          Container(
            // Profile picture
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              border: Border.all(),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10), // Add some space between profile picture and text
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Username',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                'Followers: 1000   Following: 500', // Example text
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}




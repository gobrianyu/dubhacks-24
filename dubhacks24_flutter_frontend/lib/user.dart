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
      backgroundColor: const Color.fromARGB(255, 26, 2, 37),
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
  return Expanded(
    child: GridView.count(
      crossAxisCount: 3, // 3 columns in the grid
      childAspectRatio: 1.0, // Square tiles
      children: List.generate(21, (index) => _gridTile('assets/images/pic.jpg')), // Pass image path dynamically
    ),
  );
}

Widget _gridTile(String imagePath) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: const Color.fromARGB(136, 230, 163, 255),
        width: 0.3, // Border width around each tile
      ),
    ),
    child: Center(
      child: Image.asset(imagePath), // Use imagePath for flexibility
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
              border: Border.all(color: const Color.fromARGB(255, 112, 230, 179),),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10), // Add some space between profile picture and text
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Username',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 141, 150, 252)),
              ),
              Text(
                'Followers: 1000   Following: 500', // Example text
                style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 234, 169, 105)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}




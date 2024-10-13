import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

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
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        children: List.generate(21, (index) => _gridTile('assets/images/pic.jpg', index)),
      ),
    );
  }

  Widget _gridTile(String imagePath, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageViewer(
              initialIndex: index,
              imagePaths: List.generate(21, (index) => 'assets/images/pic.jpg'),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(136, 230, 163, 255),
            width: 0.3,
          ),
        ),
        child: Center(
          child: Image.asset(imagePath),
        ),
      ),
    );
  }

  Widget _profileInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 112, 230, 179),
              ),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Username',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 141, 150, 252)),
              ),
              Text(
                'Followers: 1000   Following: 500',
                style: TextStyle(
                    fontSize: 14, color: Color.fromARGB(255, 234, 169, 105)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ImageViewer extends StatelessWidget {
  final int initialIndex;
  final List<String> imagePaths;

  const ImageViewer({super.key, required this.initialIndex, required this.imagePaths});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: PageController(initialPage: initialIndex),
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return Center(
            child: Image.asset(imagePaths[index]),
          );
        },
      ),
    );
  }
}

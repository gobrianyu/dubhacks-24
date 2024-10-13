import 'package:dubhacks24_flutter_frontend/account_provider.dart';
import 'package:dubhacks24_flutter_frontend/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  final Color backColour = Color.fromARGB(255, 26, 2, 37);
  final Color accentColour = Color.fromARGB(255, 149, 49, 109);
  final Color textColour = Colors.white;
  late final AccountProvider accProvider;

  @override
  void initState() {
    super.initState();
    accProvider = context.read<AccountProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountProvider>(
      builder: (context, accountProvider, _) {
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
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                primary: true,
                children: [
                  _profileInfo(),
                  _photoGrid(),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _photoGrid() {
    return GridView.builder(
      shrinkWrap: true,
      primary: false,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,   // Number of tiles per row
        childAspectRatio: 1.0, // Aspect ratio for each tile
      ),
      itemCount: accProvider.posts.length, // Number of posts to display
      itemBuilder: (context, index) {
        final post = accProvider.posts[index];
        return _gridTile(post, index);  // Use the post's image URL or any other property
      },
    );
  }

  Widget _gridTile(DreamPost post, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageViewer(
              initialIndex: index, // Start at the tapped image
              imagePaths: accProvider.posts.map((post) => post.imageLink).toList(), // Pass full list of image URLs
            ),
          ),
        );
      },
      child: Image(image: AssetImage(post.imageLink), fit: BoxFit.cover),
    );
  }

  Widget _profileInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 25, left: 20, right: 20),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              border: Border.all(
                color: textColour,
                width: 1.5,
              ),
              shape: BoxShape.circle, // Circular container
            ),
            child: ClipOval(
              child: Image.asset(
                accProvider.pfp, // Load the profile picture from assets
                fit: BoxFit.cover, // Ensure the image covers the circle without distortion
              ),
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                accProvider.username,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColour),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Text(
                        'Followers',
                        style: TextStyle(
                            fontSize: 14, color: textColour),
                      ),
                      Text(
                        '${accProvider.followers.length}',
                        style: TextStyle(
                            fontSize: 14, color: textColour),
                      ),
                    ],
                  ),
                  SizedBox(width: 30),
                  Column(
                    children: [
                      Text(
                        'Following',
                        style: TextStyle(
                            fontSize: 14, color: textColour),
                      ),
                      Text(
                        '${accProvider.following.length}',
                        style: TextStyle(
                            fontSize: 14, color: textColour),
                      ),
                    ],
                  ),
                ],
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

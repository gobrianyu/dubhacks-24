import 'dart:io';

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
  final Color backColour = const Color.fromARGB(255, 26, 2, 37);
  final Color accentColour = const Color.fromARGB(255, 149, 49, 109);
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
              initialIndex: index,
              posts: accProvider.posts, // Pass the full list of posts
            ),
          ),
        );
      },
      child: post.imageLink.contains('/data/user') ? Image.file(File(post.imageLink)) : Image(image: AssetImage(post.imageLink), fit: BoxFit.cover),
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
                        'Posts',
                        style: TextStyle(
                            fontSize: 12, color: textColour),
                      ),
                      Text(
                        '${accProvider.posts.length}',
                        style: TextStyle(
                            fontSize: 14, color: textColour, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30),
                  Column(
                    children: [
                      Text(
                        'Followers',
                        style: TextStyle(
                            fontSize: 12, color: textColour),
                      ),
                      Text(
                        '${accProvider.followers.length}',
                        style: TextStyle(
                            fontSize: 14, color: textColour, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30),
                  Column(
                    children: [
                      Text(
                        'Following',
                        style: TextStyle(
                            fontSize: 12, color: textColour),
                      ),
                      Text(
                        '${accProvider.following.length}',
                        style: TextStyle(
                            fontSize: 14, color: textColour, fontWeight: FontWeight.bold),
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
  final List<DreamPost> posts; // Change to a list of posts

  const ImageViewer({
    super.key,
    required this.initialIndex,
    required this.posts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: PageController(initialPage: initialIndex),
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index]; // Get the current post
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center( // logic of this format are exclusively for demo purposes.
                child: post.imageLink.contains('/data/user') ? Image.file(File(post.imageLink)) : Image.asset(post.imageLink),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.caption, // Display the post's caption
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                        softWrap: true,
                        // overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        getDate(post.time), // Display the post's time
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

String getMinute(int time) {
  if (time < 10) {
    return '0$time';
  }
  return time.toString();
}

String getDate(DateTime time) {
  return '${(time.month)}/${time.day}/${time.year}  ${time.hour}:${getMinute(time.minute)}';
}

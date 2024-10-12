import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {

  const UserPage ({super.key});

  @override
  State<UserPage> createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _photoGrid(),
            _profileInfo(),
          ],
        ),
      ),
    );
  }

  @override
  Widget _photoGrid() {
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      children: List.generate(21, (index) => _gridTile('image')),
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
          'image',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget _profileInfo() {
    return Row(
      children: [
        Container(
          // profile picture
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            border: Border.all(),
            shape: BoxShape.circle
          ),
        ),
        Text(
          '''Username
          Followers         Following''',
          style: TextStyle(fontSize: 30),
          
        )
      ],
    );
  }
}




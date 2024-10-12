import 'dart:ffi';

import 'package:flutter/material.dart';

class Socials extends StatefulWidget {
  const Socials({super.key});
  
  @override
  State<Socials> createState() => SocialsState();
}

class SocialsState extends State<Socials> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _filterBar(),
            _post()
          ],
        ),
      )
    );
  }

  Widget _postList() {
    return ListView(
      children: []
    );
  }

  Widget _post() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(),
                shape: BoxShape.circle
              ),
            ),
            Text('username'),
            Spacer(),
            Text('time')
          ],
        ),
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              border: Border.all()
            )
          ),
        )
      ],
    );
  }

  Widget _filterBar() {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      padding: const EdgeInsets.only(left: 2),
      width: MediaQuery.of(context).size.width,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.8),
        borderRadius: const BorderRadius.all(Radius.circular(16))
      ),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 44, // WARNING: NON GLOBAL CONSTANT
            child: TextField(  
              controller: searchController,
              cursorColor: Colors.black,
              cursorWidth: 1,
              style: const TextStyle(
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() => searchController.clear());
                  },
                  child: const Icon(Icons.clear, size: 18)
                )
              ),
            ),
          ),
        ],
      )
    );
  }
}

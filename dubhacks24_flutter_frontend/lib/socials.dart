import 'package:dubhacks24_flutter_frontend/post.dart';
import 'package:flutter/material.dart';

class Socials extends StatefulWidget {
  const Socials({super.key});
  
  @override
  State<Socials> createState() => SocialsState();
}

class SocialsState extends State<Socials> {
  final List<DreamPost> feed = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 26, 2, 37),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _filterBar(),
            _postList()
          ],
        ),
      )
    );
  }

  Widget _postList() {
    return Expanded(
      child: ListView.builder(
        itemCount: feed.length,
        itemBuilder: (context, index) {
          return _post(feed[index]);
        },
      ),
    );
  }

  Widget _post(DreamPost post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.only(right: 10),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromARGB(255, 112, 230, 179),),
                shape: BoxShape.circle
              ),
            ),
            Text(post.username, style: TextStyle(color: Color.fromARGB(255, 141, 150, 252)),),
            Spacer(),
            Text(getDate(post.time), style: TextStyle(color: Color.fromARGB(255, 234, 169, 105)),)
          ],
        ),
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Color.fromARGB(136, 230, 163, 255))
            )
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Text('Some really long test caption.', style: TextStyle(color: Color.fromARGB(255, 141, 150, 252)),),
        ),
        SizedBox(height: 30)
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
        color: const Color.fromARGB(255, 255, 225, 225),
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
                  color: Color.fromARGB(255, 26, 2, 37),
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

  // temp? tester function to hardcode posts in user's feed
  void initFeed() {
    final post1 = DreamPost(username: 'nano.d3m', time: DateTime.now(), profilePic: 'unknown', caption: '@dubhacks for 2024. 10th year anni!');
    final post2 = DreamPost(username: 'rando', time: DateTime.now(), profilePic: 'profilePic', caption: 'RAHHHH');
    feed.add(post1);
    feed.add(post2);
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
  final DateTime now = DateTime.now();
  if (time.year == now.year) {
    if (time.month == now.month && time.day == now.day) {
      return '${time.hour}:${time.minute}';
    }
    return '${monthAsAbbrevString(time.month)} ${time.day}';
  }
  return '${monthAsAbbrevString(time.month)} ${time.day}, ${time.year}';
}

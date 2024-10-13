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
  final Color backColour = Color.fromARGB(255, 26, 2, 37);
  final Color accentColour = Color.fromARGB(255, 149, 49, 109);
  final Color textColour = Colors.white;

  @override
  void initState() {
    super.initState();
    initFeed();
  }

  @override
  Widget build(BuildContext context) {
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          flexibleSpace: _filterBar(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _postList()
            ],
          ),
        )
      ),
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
                border: Border.all(color: textColour, width: 1.5),
                shape: BoxShape.circle
              ),
            ),
            Text(post.username, style: TextStyle(color: textColour, fontWeight: FontWeight.w600, fontSize: 17)),
            Spacer(),
            Text(getDate(post.time), style: TextStyle(color: textColour, fontSize: 15))
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
          child: Text('Some really long test caption.', style: TextStyle(color: textColour)),
        ),
        SizedBox(height: 30)
      ],
    );
  }

  Widget _filterBar() {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 15, right: 15),
      padding: const EdgeInsets.only(left: 2),
      width: MediaQuery.of(context).size.width,
      height: 32,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: textColour),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: Color.fromARGB(50, 255, 255, 255)
      ),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width - 44, // WARNING: NON GLOBAL CONSTANT
            child: TextField(  
              controller: searchController,
              cursorColor: textColour,
              cursorWidth: 1,
              style: const TextStyle(
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: textColour,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                prefixIcon: Icon(Icons.search, size: 20, color: textColour),
                suffixIcon: InkWell(
                  onTap: () {
                    setState(() => searchController.clear());
                  },
                  child: Icon(Icons.clear, size: 18, color: textColour)
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
    final post1 = DreamPost(username: 'nano.d3m', time: DateTime.now(), profilePic: 'unknown', caption: '@dubhacks for 2024. 10th year anni!', imageLink: '');
    final post2 = DreamPost(username: 'rando', time: DateTime.now(), profilePic: 'profilePic', caption: 'RAHHHH', imageLink: '');
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

String getMinute(int time) {
  if (time < 10) {
    return '0$time';
  }
  return time.toString();
}

String getDate(DateTime time) {
  final DateTime now = DateTime.now();
  if (time.year == now.year) {
    if (time.month == now.month && time.day == now.day) {
      return '${time.hour}:${getMinute(time.minute)}';
    }
    return '${monthAsAbbrevString(time.month)} ${time.day}';
  }
  return '${monthAsAbbrevString(time.month)} ${time.day}, ${time.year}';
}

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
              child: ClipOval(
                child: Image.asset(
                  post.profilePic, // Load the profile picture from assets
                  fit: BoxFit.cover, // Ensure the image covers the circle without distortion
                ),
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
            ),
            child: Image.asset(post.imageLink),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Text(post.caption, style: TextStyle(color: textColour)),
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

  void initFeed() {
    feed.add(DreamPost(username: 'dubhacks@uw', time: DateTime.parse('2024-10-13 08:44:00Z'), profilePic: 'assets/images/dubhacks_pfp.png', caption: 'Just had the craziest dream I was working on a hackathon project late into the night, but there was this eerie feeling with a pair of eyes staring at me. Anyone else ever have those unsettling dreams? 🌃🕵️ #Dreams #Hackathon', imageLink: 'assets/images/6.png'));
    feed.add(DreamPost(username: 'kcheebe', time: DateTime.parse('2024-10-13 06:35:00Z'), profilePic: 'assets/images/default.png', caption: 'Hey everyone I just had the craziest dream last night. I was walking through a lush green meadow filled with adorable llamas. They were all so fluffy and friendly, and I couldn\'t help but feel a deep connection to them. I know it sounds silly, but it really left an impression on me. Anyone else ever have dreams that feel so real? #LlamaDreams #DreamsThatFeelReal', imageLink: 'assets/images/7.png'));
    feed.add(DreamPost(username: 'tamsynnn', time: DateTime.parse('2024-10-13 06:35:00Z'), profilePic: 'assets/images/default.png', caption: 'Just had the craziest dream I was at the zoo, and all the animals could talk. The monkeys were chatting about their favorite fruits, while the lions were discussing the latest savannah gossip. Even the penguins were sharing jokes. #TalkingAnimals #ZooDreams #WildNightmares', imageLink: 'assets/images/8.png'));
    feed.add(DreamPost(username: 'mallard23', time: DateTime.parse('2024-10-13 06:35:00Z'), profilePic: 'assets/images/pic.png', caption: 'I had a pretty vivid dream last night. In it, I was standing in a lush green meadow filled with llamas. Suddenly, one of the llamas started running frantically and fell into a deep hole that seemed to appear out of nowhere. The other llamas were startled and began to panic, trying to help their fallen friend. The scene was quite surreal and left me feeling a bit uneasy when I woke up. I\'m not sure what it could mean, but it\'s definitely stuck with me.', imageLink: 'assets/images/9.png'));
    feed.add(DreamPost(username: 'nano.d3m', time: DateTime.now(), profilePic: 'assets/images/kiko.jpg', caption: '@dubhacks for 2024. 10th year anni!', imageLink: 'assets/images/sample_post_picture_1.png'));
    feed.add(DreamPost(username: 'rando', time: DateTime.now(), profilePic: 'assets/images/default.png', caption: 'RAHHHH', imageLink: 'assets/images/sample_post_picture_2.png'));
    feed.add(DreamPost(username: 'mallard23', time: DateTime.now(), profilePic: 'assets/images/pic.jpg', caption: 'Why was I dreaming of books lol', imageLink: 'assets/images/sample_post_picture_3.png'));
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

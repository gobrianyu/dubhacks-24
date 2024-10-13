import 'package:dubhacks24_flutter_frontend/post.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AccountProvider extends ChangeNotifier {
  final DateTime accountStart;
  final List<DreamPost> posts;
  String username;
  final String pfp;
  final List<String> followers;
  final List<String> following;

  static const String boxName = 'accountBox';

  AccountProvider({
    required this.username,
    required this.accountStart,
    required this.posts,
    required this.pfp,
    required this.followers,
    required this.following,
  });

  factory AccountProvider.fromHive() {
    final box = Hive.box(boxName);
    return AccountProvider(
      username: box.get('username', defaultValue: 'defaultUser'),
      accountStart: DateTime.parse(box.get('accountStart', defaultValue: DateTime.now().toIso8601String())),
      posts: [], // Load from somewhere else or store in another box
      pfp: box.get('pfp', defaultValue: 'assets/images/default.png'),
      followers: List<String>.from(box.get('followers', defaultValue: [])),
      following: List<String>.from(box.get('following', defaultValue: [])),
    );
  }

  void saveToHive() {
    final box = Hive.box(boxName);
    box.put('username', username);
    box.put('accountStart', accountStart.toIso8601String());
    box.put('pfp', pfp);
    box.put('followers', followers);
    box.put('following', following);
  }

  factory AccountProvider.fromNew({required username}) {
    return AccountProvider(username: username, accountStart: DateTime.now(), posts: [], followers: [], following: [], pfp: 'assets/images/default.png');
  }

  factory AccountProvider.demo() {
    String username = 'nano.d3m';
    return AccountProvider(username: username, accountStart: DateTime.now().subtract(Duration(days: 150)), posts: _demoPosts(username), followers: ['mallard23', 'kicheebe', 'tamsynnnn'], following: ['mallard23', 'kicheebe', 'tamsynnnn'], pfp: 'assets/images/kiko.jpg');
  }

  List<DreamPost> get myPosts => List.from(posts);

  void addPost(DreamPost post) {
    posts.add(post);
    saveToHive();
    notifyListeners();
  }

  void updateUsername(String newName) {
    username = newName;
    saveToHive();
    notifyListeners();
  }

  void addFollower(String followerName) {
    followers.add(followerName);
    saveToHive();
    notifyListeners();
  }

  void addFollowing(String followingName) {
    following.add(followingName);
    saveToHive();
    notifyListeners();
  }
}

List<DreamPost> _demoPosts(String username) {
  List<DreamPost> posts = [];
  posts.add(DreamPost(username: username, imageLink: 'assets/images/1.png', time: DateTime.parse('2024-09-20 06:18:00Z'), profilePic: '', caption: 'In a magical library, glowing books floated. I touched one, and light whisked me to my ancestors\' village. Their joys and sorrows became mine as I lived their lives. I danced at weddings and weathered storms, feeling their resilience. As I grasped their spirit, the book closed, returning me to the library. I was forever changed, now connected through time to my heritage.'));
  posts.add(DreamPost(username: username, imageLink: 'assets/images/2.png', time: DateTime.parse('2024-09-28 07:04:00Z'), profilePic: '', caption: 'In my candy town, streets flowed with chocolate rivers and gumdrop houses sparkled under a caramel sun. Lollipop trees swayed in the breeze, and every bite was sweet. Laughter echoed as we explored, tasting joy in every sugary corner.'));
  posts.add(DreamPost(username: username, imageLink: 'assets/images/3.png', time: DateTime.parse('2024-09-30 11:20:00Z'), profilePic: '', caption: 'In the enchanted forest, sunlight filtered through emerald leaves, casting a magical glow on the path ahead. Whispers of ancient trees guided me to a glimmering pond, where shimmering fairies danced above the water. As I stepped closer, their laughter filled the air, inviting me to join their world—a realm where dreams and reality intertwined, promising endless adventures.'));
  posts.add(DreamPost(username: username, imageLink: 'assets/images/4.png', time: DateTime.parse('2024-10-01 10:43:00Z'), profilePic: '', caption: 'In the futuristic city, skyscrapers soared like silver needles, piercing a sky alive with drones and neon lights. Holograms flickered, advertising wonders beyond imagination. As I strolled through vibrant streets, robotic companions greeted me, sharing stories of technology\'s marvels. Hovercars zipped overhead, and the air buzzed with possibilities—a world where dreams of tomorrow came alive today.'));
  posts.add(DreamPost(username: username, imageLink: 'assets/images/5.png', time: DateTime.parse('2024-10-11 08:24:00Z'), profilePic: '', caption: 'In a sunlit meadow, a curious group of llamas tumbled into a deep hole, their woolly forms wriggling in surprise. Inside, they discovered a hidden cavern adorned with glowing crystals and lush ferns. As they explored, they playfully nibbled on sparkling plants, their laughter echoing through the chamber, turning their unexpected adventure into a whimsical day of discovery.'));
  
  return posts;
}
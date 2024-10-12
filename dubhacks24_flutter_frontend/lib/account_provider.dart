import 'package:dubhacks24_flutter_frontend/post.dart';
import 'package:flutter/material.dart';

class AccountProvider extends ChangeNotifier {
  final List<DreamPost> posts;
  String username;
  // final pfp;
  final List<String> followers;
  final List<String> following;
  
  AccountProvider({required this.username}): posts = [], followers = [], following = [];

  List<DreamPost> get myPosts => List.from(posts);

  void _addPost(DreamPost post) {
    posts.add(post);
    notifyListeners();
  }

  void _updateUsername(String newName) {
    username = newName;
    notifyListeners();
  }

  void _addFollower(String followerName) {
    followers.add(followerName);
  }

  void _addFollowing(String followingName) {
    following.add(followingName);
  }
}
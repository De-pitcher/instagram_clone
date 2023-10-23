import 'package:flutter/material.dart';

import '../screens/add_post_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/search_screen.dart';

const webScreensize = 600;

const homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text('Favorite'),
  Text('Profile'),
];

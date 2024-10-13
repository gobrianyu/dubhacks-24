import 'package:dubhacks24_flutter_frontend/account_provider.dart';
import 'package:dubhacks24_flutter_frontend/diary_entry.dart';
import 'package:dubhacks24_flutter_frontend/post.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Diary extends StatefulWidget {
  final AccountProvider account;
  const Diary({required this.account, super.key});
  
  @override
  State<Diary> createState() => DiaryState();
}

class DiaryState extends State<Diary> {
  final List<DreamPost> feed = [];
  DateTime selectedDay = DateTime.now(); // Track the selected day
  CalendarFormat _calendarFormat = CalendarFormat.week;

  @override
  void initState() {
    super.initState();
    initFeed();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _calendar(),
                const SizedBox(height: 20),
                _postList(), // display posts matching the selected day
              ],
            ),
            selectedDay.day == now.day && selectedDay.month == now.month && selectedDay.year == now.year 
            ? GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DiaryEntry()),
                );
              },
              child: Row(
                children: [
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue
                    ),
                    child: Icon(Icons.draw, color: Colors.white, size: 40)
                  ),
                ],
              ),
            )
            : Container()
          ],
        ),
      ),
    );
  }

  Widget _calendar() {
    return TableCalendar(
      focusedDay: selectedDay, // set focused day to the selected day
      firstDay: DateTime.now().subtract(const Duration(days: 100)),
      lastDay: DateTime.now(),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          this.selectedDay = selectedDay; //update selected day
        });
      },
      availableCalendarFormats: const {
        CalendarFormat.month: 'Week',
        CalendarFormat.twoWeeks: 'Month',
        CalendarFormat.week: '2 Week', // broken package wtf
      },
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
    );
  }

  Widget _postList() {
    // filter posts for selected day
    List<DreamPost> postsForSelectedDay = feed.where((post) {
      return post.time.year == selectedDay.year &&
             post.time.month == selectedDay.month &&
             post.time.day == selectedDay.day;
    }).toList();

    if (postsForSelectedDay.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(getDate(selectedDay), style: TextStyle(fontWeight: FontWeight.w500)),
          SizedBox(height: 10),
          Text('No posts for this day.'),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(getDate(selectedDay), style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(height: 10),
        ...postsForSelectedDay.map((post) => _post(post)).toList()
      ]
    );
  }

  Widget _post(DreamPost post) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.username, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('${post.time.hour}:${post.time.minute}'),
          const SizedBox(height: 5),
          Text(post.caption),
          const Divider(),
        ],
      ),
    );
  }

  void initFeed() {
    final post1 = DreamPost(username: 'nano.d3m', time: DateTime.now().subtract(const Duration(days: 1)), profilePic: 'unknown', caption: '@dubhacks for 2024. 10th year anni!');
    final post2 = DreamPost(username: 'rando', time: DateTime.now(), profilePic: 'profilePic', caption: 'RAHHHH');
    feed.add(post1);
    feed.add(post2);
  }
}

// Helper functions remain unchanged
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
    return '${monthAsAbbrevString(time.month)} ${time.day}';
  }
  return '${monthAsAbbrevString(time.month)} ${time.day}, ${time.year}';
}
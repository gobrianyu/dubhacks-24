import 'dart:io';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:dubhacks24_flutter_frontend/account_provider.dart';
import 'package:dubhacks24_flutter_frontend/diary_entry.dart';
import 'package:dubhacks24_flutter_frontend/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Diary extends StatefulWidget {
  final AccountProvider account;
  const Diary({required this.account, super.key});
  
  @override
  State<Diary> createState() => DiaryState();
}

class DiaryState extends State<Diary> {
  final CountDownController _countdownController = CountDownController();
  DateTime selectedDay = DateTime.now(); // Track the selected day
  CalendarFormat _calendarFormat = CalendarFormat.week;
  bool lockout = false;
  final Color backColour = Color.fromARGB(255, 26, 2, 37);
  final Color accentColour = Color.fromARGB(255, 149, 49, 109);
  final Color textColour = Colors.white;
  late final AccountProvider accProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _countdownController.start();
    });
    accProvider = context.read<AccountProvider>();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
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
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ListView(
                    children: [
                      _calendar(),
                      const SizedBox(height: 20),
                      _postList(), // display posts matching the selected day
                    ],
                  ),
                  selectedDay.day == now.day && selectedDay.month == now.month && selectedDay.year == now.year 
                        && !lockout 
                        && accProvider.posts.where((e) => e.time.day == now.day && e.time.month == now.month && e.time.year == now.year).toList().isEmpty
                  ? Stack(
                    alignment: Alignment.bottomRight,
                      children: [
                        // Circular countdown timer behind the button
                        Positioned(
                          right: 0,
                          bottom: 75,
                          child: CircularCountDownTimer(
                            duration: 10, // 10 seconds countdown
                            initialDuration: 0,
                            controller: _countdownController,
                            width: 80, // Adjust width
                            height: 80, // Adjust height
                            ringColor: Colors.purpleAccent[100]!,
                            fillColor: Colors.grey[300]!,
                            backgroundColor: Colors.purple[500],
                            strokeWidth: 10.0,
                            textStyle: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textFormat: CountdownTextFormat.S,
                            isReverse: true,
                            isTimerTextShown: true,
                            autoStart: false, // Starts in initState
                            onComplete: () {
                              debugPrint('Countdown Ended');
                              setState(() => lockout = true);
                            },
                          ),
                        ),
                        // GestureDetector with a button in front of the timer
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DiaryEntry()), // Assumed DiaryEntry is another page
                            );
                          },
                          child: Row(
                            children: [
                              Spacer(),
                              Container(
                                margin: EdgeInsets.only(bottom: 75),
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: textColour),
                                child: Icon(Icons.draw,
                                    color: backColour, size: 40),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Container()
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget _calendar() {
    return TableCalendar(
      focusedDay: selectedDay, // set focused day to the selected day
      currentDay: selectedDay,
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
      calendarStyle: CalendarStyle(
        defaultTextStyle: TextStyle(color: textColour), // Default day text
        weekendTextStyle: TextStyle(color: Colors.redAccent), // Weekend day text
        selectedDecoration: BoxDecoration(
          color: Colors.deepPurple, // Selected day background color
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Color.fromARGB(255, 176, 91, 170), // Current day background color
          shape: BoxShape.circle,
        ),
        todayTextStyle: TextStyle(color: textColour), // Current day text color
        outsideDaysVisible: false, // Hide days outside the selected month
      ),
      
      headerStyle: HeaderStyle(
        titleTextStyle: TextStyle(color: textColour), // Header title text color
        formatButtonTextStyle: TextStyle(color: textColour),
        formatButtonDecoration: BoxDecoration(
          color: Colors.grey.shade800, // Format button background
          borderRadius: BorderRadius.circular(16.0),
        ),
        leftChevronIcon: Icon(Icons.chevron_left, color: textColour),
        rightChevronIcon: Icon(Icons.chevron_right, color: textColour),
      ),

      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.grey.shade400), // Weekday labels
        weekendStyle: TextStyle(color: Colors.redAccent), // Weekend labels
      ),
    );
  }

  Widget _postList() {
    // filter posts for selected day
    List<DreamPost> postsForSelectedDay = accProvider.posts.where((post) {
      return post.time.year == selectedDay.year &&
             post.time.month == selectedDay.month &&
             post.time.day == selectedDay.day;
    }).toList();

    if (postsForSelectedDay.isEmpty) {
      return Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(getDate(selectedDay), style: TextStyle(fontWeight: FontWeight.w500, color: textColour)),
              SizedBox(height: 10),
              Text('No post for this day.', style: TextStyle(color: textColour)),
            ],
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(getDate(selectedDay), style: TextStyle(fontWeight: FontWeight.w500, color: textColour)),
        SizedBox(height: 10),
        ...postsForSelectedDay.map((post) => _post(post))
      ]
    );
  }

  Widget _post(DreamPost post) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${post.time.hour}:${getMinute(post.time.minute)}', style: TextStyle(color: textColour)),
            const Divider(),
            post.imageLink != '' ? post.imageLink.contains('/data/user') ? Image.file(File(post.imageLink)) : Image(image: AssetImage(post.imageLink)) : const SizedBox(),
            const SizedBox(height: 5),
            Text(post.caption, style: TextStyle(color: textColour)),
          ],
        ),
      ),
    );
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

String getMinute(int time) {
  if (time < 10) {
    return '0$time';
  }
  return time.toString();
}

String getDate(DateTime time) {
  final DateTime now = DateTime.now();
  if (time.year == now.year) {
    return '${monthAsAbbrevString(time.month)} ${time.day}';
  }
  return '${monthAsAbbrevString(time.month)} ${time.day}, ${time.year}';
}
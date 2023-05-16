import 'package:chat_app/chat/screens/friends_list/friends.dart';
// import 'package:chat_app/chat/screens/messages/chat.dart';
import 'package:chat_app/chat/screens/profile/profile.dart';
import 'package:chat_app/chat/screens/messages/list_chat.dart';
//import 'package:chat_app/chat/screens/video_call/video_call.dart';
import 'package:chat_app/chat/services/notification_services.dart';
import 'package:chat_app/chat/services/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class YouAreIn extends StatefulWidget {
  const YouAreIn({Key? key}) : super(key: key);

  @override
  State<YouAreIn> createState() => _YouAreInState();
}

class _YouAreInState extends State<YouAreIn> with WidgetsBindingObserver {
  int currentTab = 0;
  List<Widget> screens = [
    const ListChat(),
    const Friends(),
    const Profile(),
  ];

  DateTime? currentBackPressTime;
  final PageStorageBucket bucket = PageStorageBucket();
  // bool _isLoading = true;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setUserActive();
    } else {
      setUserOffline();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: screens[currentTab],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        elevation: 5,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() => currentTab = 0);
                },
                child: Icon(
                  currentTab == 0
                      ? FontAwesomeIcons.solidComment

                      /// trò chuyện icon tasbar
                      : FontAwesomeIcons.comment,
                  color: currentTab == 0
                      ? Color.fromARGB(255, 25, 255, 55)
                      : Colors.black,
                  size: 25,
                ),
              ),
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() => currentTab = 1);
                },
                child: Icon(
                  currentTab == 1
                      ? FontAwesomeIcons.userFriends

                      /// bạn bè icon tasbar
                      : FontAwesomeIcons.userFriends,
                  color: currentTab == 1
                      ? Color.fromARGB(255, 25, 255, 55)
                      : Colors.black,
                  size: 25,
                ),
              ),
              MaterialButton(
                minWidth: 40,
                onPressed: () {
                  setState(() => currentTab = 2);
                },
                child: Icon(
                  currentTab == 2
                      ? FontAwesomeIcons.cog

                      /// cài đặt icon tasbar
                      : FontAwesomeIcons.cog,
                  color: currentTab == 2
                      ? Color.fromARGB(255, 25, 255, 55)
                      : Colors.black,
                  size: 24,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

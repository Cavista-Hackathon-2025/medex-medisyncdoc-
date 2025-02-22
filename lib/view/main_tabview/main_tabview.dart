import 'package:flutter/material.dart';
import '../../view/about/notification_view.dart';
import '../../common/color_extension.dart';
import '../../common_widget/tab_button.dart';

import '../about/about_view.dart';

import '../home/home_view.dart';
import '../profile/profile_view.dart';
import '../schedule/schedule_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selctTab = 2;
  PageStorageBucket storageBucket = PageStorageBucket();
  Widget selectPageView = const HomeView();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: storageBucket, child: selectPageView),
      backgroundColor: const Color(0xfff5f5f5),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () {
            if (selctTab != 2) {
              selctTab = 2;
              selectPageView = const HomeView();
            }
            if (mounted) {
              setState(() {});
            }
          },
          shape: const CircleBorder(),
          backgroundColor: selctTab == 2 ? TColor.primary : TColor.placeholder,
          child: Image.asset(
            "assets/img/tab_home.png",
            width: 30,
            height: 30,
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: TColor.white,
        shadowColor: Colors.black,
        elevation: 1,
        notchMargin: 12,
        height: 64,
        shape: const CircularNotchedRectangle(),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: TabButton(
                    title: "notification",
                    icon: "assets/img/more_notification.png",
                    onTap: () {
                      if (selctTab != 1) {
                        selctTab = 1;
                        selectPageView = const NotificationsView();
                      }
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    isSelected: selctTab == 1),
              ),

              Flexible(
                child: TabButton(
                    title: "Schedule",
                    icon: "assets/img/tab_schedule.png",
                    onTap: () {
                      if (selctTab != 0) {
                        selctTab = 0;
                        selectPageView = const ScheduleView();
                      }
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    isSelected: selctTab == 0),
              ),

              const SizedBox(width: 40, height: 40),

              Flexible(
                child: TabButton(
                    title: "Profile",
                    icon: "assets/img/tab_profile.png",
                    onTap: () {
                      if (selctTab != 3) {
                        selctTab = 3;
                        selectPageView = const ProfileView();
                      }
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    isSelected: selctTab == 3),
              ),

              Flexible(
                child: TabButton(
                    title: "About",
                    icon: "assets/img/tab_about.png",
                    onTap: () {
                      if (selctTab != 4) {
                        selctTab = 4;
                        selectPageView = const AboutView();
                      }
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    isSelected: selctTab == 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


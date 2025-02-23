import 'package:flutter/material.dart';
import 'on_boarding_view.dart';
import '../main_tabview/main_tabview.dart';
import '../../common/globs.dart';

class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  @override
  void initState() {
    super.initState();
    goWelcomePage();
  }

  void goWelcomePage() async {
    await Future.delayed(const Duration(seconds: 5)); // Increased delay to 5 seconds
    welcomePage();
  }

  void welcomePage() {
    if (Globs.udValueBool(Globs.userLogin)) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainTabView()), // Prevents going back to splash screen
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoardingView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/img/splash_bg.png",
            width: media.width,
            height: media.height,
            fit: BoxFit.cover,
          ),
          const Positioned(
            bottom: 80,
            child: CircularProgressIndicator(), // Loading indicator while waiting
          ),
        ],
      ),
    );
  }
}


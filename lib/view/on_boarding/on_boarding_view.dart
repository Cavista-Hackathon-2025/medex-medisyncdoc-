import 'package:flutter/material.dart';
import '../login/welcome_view.dart';
import '../../common/color_extension.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int selectPage = 0;
  PageController controller = PageController();

  List pageArr = [
    {
      "title": "Stay on Top of Your Medication",
      "subtitle":
      "Track patient history, treatments,\nprescriptions in real-time—ensuring\nseamless continuity of care.",
      "image": "assets/img/on_boarding_1.png",
    },
    {
      "title": "Daily Workouts for a Healthier you",
      "subtitle": "AI-driven insights and encrypted cloud storage\naccuracy, and security in every interaction.",
      "image": "assets/img/on_boarding_2.png",
    },
    {
      "title": "Medical History, Always Accessible ",
      "subtitle":
      "Effortlessly manage patient records, prescriptions, and video documentation.",
      "image": "assets/img/on_boarding_3.png",
    },
  ];

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setState(() {
        selectPage = controller.page?.round() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: controller,
            itemCount: pageArr.length,
            itemBuilder: ((context, index) {
              var pObj = pageArr[index] as Map? ?? {};

              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: media.height * 0.05), // Add spacing
                    Container(
                      width: media.width,
                      height: media.width * 0.6,
                      alignment: Alignment.center,
                      child: Image.asset(
                        pObj["image"].toString(),
                        width: media.width * 0.65,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: media.width * 0.1), // Add spacing
                    Text(
                      pObj["title"].toString(),
                      style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: media.width * 0.05),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        pObj["subtitle"].toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(height: media.width * 0.10), // Prevent overflow
                  ],
                ),
              );
            }),
          ),

          // Positioned "Skip" button at the top-right corner
          Positioned(
            top: 50, // Adjust for status bar height
            right: 20,
            child: GestureDetector(
              onTap: () {
                // Skip onboarding and go to WelcomeView
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeView(),
                  ),
                );
              },
              child: Text(
                "Skip",
                style: TextStyle(
                  color: TColor.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Page Indicator
          Positioned(
            bottom: media.height * 0.08,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: pageArr.map((e) {
                var index = pageArr.indexOf(e);
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: 6,
                  decoration: BoxDecoration(
                      color: index == selectPage
                          ? TColor.primary
                          : TColor.placeholder,
                      borderRadius: BorderRadius.circular(4)),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


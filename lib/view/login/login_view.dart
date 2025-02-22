import 'package:flutter/material.dart';
import '../../common/extension.dart';
import '../../common/globs.dart';
import '../../common_widget/round_button.dart';
import '../../view/login/rest_password_view.dart';
import '../../view/login/sing_up_view.dart';
import '../../common/service_call.dart';
import '../../common_widget/round_icon_button.dart';
import '../../common_widget/round_textfield.dart';
import '../main_tabview/main_tabview.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool isDoctor = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top area with app logo.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                "assets/img/app_logo.png",
                width: 165.15,
                height: 30,
                fit: BoxFit.contain,
              ),
            ),
            // Heading area.
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Login",
                    style: TextStyle(
                      color: Color(0xff4A4B4D), // primaryText
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Join us and take control of your health—track\n medications, stay active, and access your \ntreatment history",
                    style: TextStyle(
                      color: Color(0xff7C7D7E), // secondaryText
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Container with rounded top edges for the login form and sign-up prompt.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Adjusted padding
              decoration: const BoxDecoration(
                color: Color(0xffC7E4E4),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  // Doctor / Patient Toggle
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xffFEFEFE),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isDoctor = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: isDoctor ? const Color(0xffF39237) : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Doctor",
                                style: TextStyle(
                                  color: isDoctor ? Colors.white : Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isDoctor = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                color: !isDoctor ? const Color(0xffF39237) : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "Patient",
                                style: TextStyle(
                                  color: !isDoctor ? Colors.white : Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15), // Adds space between toggle and fields

                  RoundTextfield(
                    hintText: "Your Email",
                    controller: txtEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 15), // Reduced space

                  RoundTextfield(
                    hintText: "Password",
                    controller: txtPassword,
                    obscureText: true,
                  ),
                  const SizedBox(height: 15), // Reduced space

                  RoundButton(
                    title: "Login",
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainTabView(),
                        ),
                            (route) => false,
                      );
                    },
                  ),
                  const SizedBox(height: 4),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPasswordView(),
                        ),
                      );
                    },
                    child: const Text(
                      "Forgot your password?",
                      style: TextStyle(
                        color: Color(0xff7C7D7E),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),

                  const Text(
                    "or Login With",
                    style: TextStyle(
                      color: Color(0xff7C7D7E),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),

                  RoundIconButton(
                    icon: "assets/img/facebook_logo.png",
                    title: "Login with Facebook",
                    color: const Color(0xff367FC0),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 15), // Reduced space

                  RoundIconButton(
                    icon: "assets/img/google_logo.png",
                    title: "Login with Google",
                    color: const Color(0xffDD4B39),
                    onPressed: () {},
                  ),
                  const SizedBox(height: 20), // Reduced space

                  // Sign-up prompt placed inside the same container.
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                      color: Color(0xffB6B7B7),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUpView(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            "Don't have an Account? ",
                            style: TextStyle(
                              color: Color(0xff7C7D7E),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Color(0xff0E79B2),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

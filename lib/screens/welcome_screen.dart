import 'package:flutter/material.dart';
import 'package:sky_techiez/screens/create_account_screen.dart';
import 'package:sky_techiez/screens/login_screen.dart';
import 'package:sky_techiez/theme/app_theme.dart';
import 'package:sky_techiez/widgets/custom_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Center(
                child: const Text(
                  'WELCOME TO',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: AppColors.white,
                  ),
                ),
              ),
              Center(
                child: Image.asset(
                  'assets/images/SkyLogo.png',
                  height: 200,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                '24/7 technical support made easy—fast, reliable solutions to keep your devices running smoothly and stress-free.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.white,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              CustomButton(
                text: 'Create New Account',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateAccountScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Divider(color: AppColors.grey),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(color: AppColors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Sign In',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

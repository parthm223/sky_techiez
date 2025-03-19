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
              const Text(
                'DIGITAL IT',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: AppColors.white,
                ),
              ),
              const Text(
                'SOLUTION IN NEW YORK',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.0,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: 60,
                height: 4,
                color: AppColors.primaryBlue,
              ),
              const SizedBox(height: 40),
              const Text(
                'We provide innovative technology solutions to help businesses grow and succeed in the digital age.',
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

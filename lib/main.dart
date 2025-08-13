import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sky_techiez/controllers/theme_controller.dart';

import 'package:sky_techiez/screens/about_us_screen.dart';
import 'package:sky_techiez/screens/create_account_email_screen.dart';
import 'package:sky_techiez/screens/create_account_mobile_screen.dart';
import 'package:sky_techiez/screens/create_account_screen.dart';
import 'package:sky_techiez/screens/create_password_screen.dart';
import 'package:sky_techiez/screens/create_ticket_screen.dart';
import 'package:sky_techiez/screens/drivers_license_capture_screen.dart';
import 'package:sky_techiez/screens/edit_profile_screen.dart';
import 'package:sky_techiez/screens/forgot_password_screen.dart';
import 'package:sky_techiez/screens/government_id_capture_screen.dart';
import 'package:sky_techiez/screens/home_content.dart';
import 'package:sky_techiez/screens/home_screen.dart';
import 'package:sky_techiez/screens/login_screen.dart';
import 'package:sky_techiez/screens/owen_agreement_screen.dart';
import 'package:sky_techiez/screens/passport_capture_screen.dart';
import 'package:sky_techiez/screens/privacy_policy_screen.dart';
import 'package:sky_techiez/screens/profile_screen.dart';
import 'package:sky_techiez/screens/cancellation_policy_screen.dart';
import 'package:sky_techiez/screens/services_screen.dart';
import 'package:sky_techiez/screens/splas_screen.dart';
import 'package:sky_techiez/screens/payment/subscriptions_screen.dart';
import 'package:sky_techiez/screens/terms_conditions_screen.dart';
import 'package:sky_techiez/screens/ticket_status_screen.dart';
import 'package:sky_techiez/screens/upload_selfie_screen.dart';
import 'package:sky_techiez/screens/verification_complete_screen.dart';
import 'package:sky_techiez/screens/welcome_screen.dart';
import 'package:sky_techiez/screens/theme_settings_screen.dart';
import 'package:sky_techiez/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize ThemeController
  Get.put(ThemeController());

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();

    return Obx(() => GetMaterialApp(
          title: 'Sky Techiez',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(),
          darkTheme: AppTheme.darkTheme(),
          themeMode: themeController.flutterThemeMode,
          initialRoute: '/splash',
          getPages: [
            GetPage(name: '/splash', page: () => const SplashScreen()),
            GetPage(name: '/aboutUs', page: () => const AboutUsScreen()),
            GetPage(
                name: '/createAccountEmail',
                page: () => const CreateAccountEmailScreen()),
            GetPage(
                name: '/createAccountMobile',
                page: () => const CreateAccountMobileScreen()),
            GetPage(
                name: '/createAccount',
                page: () => const CreateAccountScreen()),
            GetPage(
                name: '/createPassword',
                page: () => const CreatePasswordScreen()),
            GetPage(
                name: '/createTicket', page: () => const CreateTicketScreen()),
            GetPage(
                name: '/driversLicenseCapture',
                page: () => const DriversLicenseCaptureScreen()),
            GetPage(
                name: '/editProfile', page: () => const EditProfileScreen()),
            GetPage(
                name: '/forgotPassword',
                page: () => const ForgotPasswordScreen()),
            GetPage(
                name: '/governmentIdCapture',
                page: () => const GovernmentIdCaptureScreen()),
            GetPage(name: '/homeContent', page: () => HomeContent()),
            GetPage(name: '/home', page: () => const HomeScreen()),
            GetPage(name: '/login', page: () => const LoginScreen()),
            GetPage(
                name: '/skyTechiezAgreement',
                page: () => const SkyTechiezAgreementScreen()),
            GetPage(
                name: '/passportCapture',
                page: () => const PassportCaptureScreen()),
            GetPage(
                name: '/privacyPolicy',
                page: () => const PrivacyPolicyScreen()),
            GetPage(name: '/profile', page: () => const ProfileScreen()),
            GetPage(
                name: '/cancellationPolicy',
                page: () => CancellationPolicyScreen()),
            GetPage(name: '/services', page: () => const ServicesScreen()),
            GetPage(
                name: '/subscriptions',
                page: () => const SubscriptionsScreen()),
            GetPage(
                name: '/termsConditions',
                page: () => const TermsConditionsScreen()),
            GetPage(
                name: '/ticketStatus', page: () => const TicketStatusScreen()),
            GetPage(
                name: '/uploadSelfie', page: () => const UploadSelfieScreen()),
            GetPage(
                name: '/verificationComplete',
                page: () => const VerificationCompleteScreen()),
            GetPage(name: '/welcome', page: () => const WelcomeScreen()),
            GetPage(
                name: '/themeSettings',
                page: () => const ThemeSettingsScreen()),
          ],
        ));
  }
}

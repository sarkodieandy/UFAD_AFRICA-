import 'package:flutter/material.dart';
import 'package:ufad/setup_business/business_setup_screens/business_activity.dart';
import 'package:ufad/setup_business/business_setup_screens/business_sucess_screen.dart';
import 'package:ufad/setup_business/business_setup_screens/owner_info_screen.dart';
import 'package:ufad/setup_business/business_setup_screens/business_info_screen.dart';

import 'package:ufad/setup_business/business_setup_screens/support_needs.dart';
import 'package:ufad/setup_business/business_setup_screens/consent_screen.dart';

import 'package:ufad/startup_&_onboarding/login.dart';
import 'package:ufad/startup_&_onboarding/register.dart';
import 'package:ufad/startup_&_onboarding/splash_screen.dart';
import 'package:ufad/startup_&_onboarding/startup_screen.dart';
import 'package:ufad/startup_&_onboarding/terms%20&conditions.dart';
// ...other imports

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  '/startup': (context) => const StartupScreen(),
  '/login': (context) => const LoginScreen(),
  '/register': (context) => const RegisterScreen(),
  '/terms': (context) => const TermsConditionsScreen(),
  '/owner-info': (context) => const OwnerInfoScreen(),
  '/business-info': (context) => const BusinessInfoScreen(),
  '/business-activity': (context) => const BusinessActivityScreen(),
  '/support-needs': (context) => const SupportNeedsScreen(),
  '/consent': (context) => const ConsentScreen(),
  '/registration-success':
      (context) => const BusinessRegistrationSuccessScreen(),
  // ...other routes
};

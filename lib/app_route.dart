import 'package:flutter/material.dart';
import 'package:ufad/Pos/features/pos_screen.dart';
import 'package:ufad/dashboad/dashboard_screen.dart';

// Main App Screens
import 'package:ufad/payments_management/payment_screen.dart';

import 'package:ufad/customers/customer_screen.dart';

import 'package:ufad/products/product_screen.dart';
import 'package:ufad/setup_business/business_setup_screens/business_activity.dart';
import 'package:ufad/setup_business/business_setup_screens/business_info_screen.dart';
import 'package:ufad/setup_business/business_setup_screens/business_sucess_screen.dart';
import 'package:ufad/setup_business/business_setup_screens/consent_screen.dart';
import 'package:ufad/setup_business/business_setup_screens/owner_info_screen.dart';
import 'package:ufad/setup_business/business_setup_screens/support_needs.dart';
import 'package:ufad/startup_&_onboarding/login.dart';
import 'package:ufad/startup_&_onboarding/splash_screen.dart';
import 'package:ufad/startup_&_onboarding/startup_screen.dart';
import 'package:ufad/startup_&_onboarding/terms%20&conditions.dart';
import 'package:ufad/stocks/stock_screen.dart';
import 'package:ufad/suppliers/supplier_screen.dart';

// Business Registration Screens

final Map<String, WidgetBuilder> appRoutes = {
  // Auth & Onboarding Routes
  '/': (context) => const SplashScreen(),
  '/startup': (context) => const StartupScreen(),
  '/login': (context) => const LoginScreen(),
  '/terms': (context) => const TermsConditionsScreen(),
  
  // Business Registration Flow
  '/owner-info': (context) => const OwnerInfoScreen(),
  '/business-info': (context) => const BusinessInfoScreen(),
  '/business-activity': (context) => const BusinessActivityScreen(),
  '/support-needs': (context) => const SupportNeedsScreen(),
  '/consent': (context) => const ConsentScreen(),
  '/registration-success': (context) => const BusinessRegistrationSuccessScreen(),
  
  // Main App Routes
  '/dashboard': (context) => const DashboardScreen(),
  '/products': (context) => const ProductScreen(),
  '/stocks': (context) => const StockScreen(),
  '/customers': (context) => const CustomerScreen(),
  '/suppliers': (context) => const SupplierScreen(),
  '/pos': (context) => const PosScreen(),
  '/payments': (context) => const PaymentScreen(),
  
  // Add other routes as needed
};
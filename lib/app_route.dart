import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Dashboard & Core
import 'package:ufad/Dashboard/dashboard_screen.dart';

// POS
import 'package:ufad/Pos/point_of%20_sale.dart';
import 'package:ufad/Pos/provider/pos_provider.dart';

// Customers
import 'package:ufad/customers/customer_screen.dart';
import 'package:ufad/customers/providers/customer_provider.dart';

// Loans
import 'package:ufad/loans/apply_loan.dart';
import 'package:ufad/loans/repay-loan.dart';

// Payments
import 'package:ufad/payments_management/payment_management.dart';
import 'package:ufad/payments_management/providers/payment_provider.dart';

// Business Registration
import 'package:ufad/setup_business/business_setup_screens/business_activity.dart';
import 'package:ufad/setup_business/business_setup_screens/business_sucess_screen.dart';
import 'package:ufad/setup_business/business_setup_screens/owner_info_screen.dart';
import 'package:ufad/setup_business/business_setup_screens/business_info_screen.dart';
import 'package:ufad/setup_business/business_setup_screens/support_needs.dart';
import 'package:ufad/setup_business/business_setup_screens/consent_screen.dart';

// Auth / Onboarding
import 'package:ufad/startup_&_onboarding/login.dart';
import 'package:ufad/startup_&_onboarding/splash_screen.dart';
import 'package:ufad/startup_&_onboarding/startup_screen.dart';
import 'package:ufad/startup_&_onboarding/terms%20&conditions.dart';

// Products
import 'package:ufad/products/product_screen.dart';

// Stocks
import 'package:ufad/stocks/stock_screen.dart';
import 'package:ufad/stocks/providers/stock_provider.dart';
import 'package:ufad/supplier/provider/supplier_provider.dart';
import 'package:ufad/supplier/suplier_management_screen.dart';

// Suppliers (add these imports)

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => const SplashScreen(),
  '/startup': (context) => const StartupScreen(),
  '/login': (context) => const LoginScreen(),
  '/terms': (context) => const TermsConditionsScreen(),
  '/owner-info': (context) => const OwnerInfoScreen(),
  '/business-info': (context) => const BusinessInfoScreen(),
  '/business-activity': (context) => const BusinessActivityScreen(),
  '/support-needs': (context) => const SupportNeedsScreen(),
  '/consent': (context) => const ConsentScreen(),
  '/registration-success':
      (context) => const BusinessRegistrationSuccessScreen(),
  '/dashboard': (context) => const DashboardScreen(),
  '/products': (context) => const ProductScreen(),
  '/stock-management':
      (context) => ChangeNotifierProvider(
        create: (_) => StockProvider(),
        child: const StockManagementScreen(),
      ),
  '/customer-management':
      (context) => ChangeNotifierProvider(
        create: (_) => CustomerProvider(),
        child: const CustomerManagementScreen(),
      ),
  '/supplier-management':
      (context) => ChangeNotifierProvider(
        create: (_) => SupplierProvider(),
        child: const SupplierManagementScreen(),
      ),
  '/apply-loan':
      (context) => ChangeNotifierProvider(
        create: (_) => LoanProvider(),
        child: const ApplyLoanScreen(),
      ),
  '/repay-loan':
      (context) => ChangeNotifierProvider(
        create: (_) => RepayLoanProvider(),
        child: const RepayLoanScreen(),
      ),
  '/payment-management':
      (context) => ChangeNotifierProvider(
        create: (_) => PaymentProvider(),
        child: const PaymentManagementScreen(),
      ),
  '/point-of-sale':
      (context) => ChangeNotifierProvider(
        create: (_) => POSProvider(),
        child: const PointOfSaleScreen(),
      ),
  // Add more routes as needed
};

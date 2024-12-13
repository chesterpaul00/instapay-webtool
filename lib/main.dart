import 'package:flutter/material.dart';
import 'package:instapay_webtool_provider_test/provider/user_provider.dart';
import 'package:instapay_webtool_provider_test/provider/transaction_provider.dart'; // Import the TransactionProvider
import 'package:instapay_webtool_provider_test/screens/dashboard_screen.dart';
import 'package:instapay_webtool_provider_test/screens/ips_screen.dart';
// import 'package:instapay_webtool_provider_test/screens/register_screen.dart';
import 'package:instapay_webtool_provider_test/screens/user_table.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/dashboard_screen_prod.dart';
import 'screens/login_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String initialRoute = "/login";
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('accessToken'); // Correct key
    print("Token Retrieved During Main Initialization: $token");

    // Confirm if token is retrieved
    if (token != null) {
      initialRoute = "/dashboard";
    }
  } catch (e) {
    // Log the error or show an alert for debugging
    debugPrint('Error initializing SharedPreferences: $e');
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),  // Initialize the UserProvider
        ChangeNotifierProvider(create: (_) => TransactionProvider()),  // Initialize the TransactionProvider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instapay Webtool',
        theme: ThemeData(primarySwatch: Colors.red),
        initialRoute: initialRoute,
        routes: {
          "/login": (context) => LoginScreen(),
          // "/register": (context) => RegisterScreen(),
          "/dashboard": (context) => DashboardScreen(),
          "/usertable": (context) => UserTableScreen(),
          "/ipstable": (context) => IpsScreen(),
          "/dashboardprod": (context) => DashboardScreenProd(),
        },
      ),
    );
  }
}

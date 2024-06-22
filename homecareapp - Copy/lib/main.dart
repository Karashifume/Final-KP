import 'package:flutter/material.dart';
import 'package:homecareapp/main_layout.dart';
import 'package:homecareapp/models/auth_model.dart';
import 'package:homecareapp/screens/auth_page.dart';
// import 'package:homecareapp/screens/Waktu.dart';
import 'package:homecareapp/screens/Booking.dart';
import 'package:homecareapp/screens/success_booked.dart';
import 'package:homecareapp/screens/doctor_details.dart';
import 'package:homecareapp/utils/config.dart';
import 'package:provider/provider.dart';
import 'package:homecareapp/data/user_data.dart'; // Add this import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This is for push navigator
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    // Define ThemeData here
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthModel>(
          create: (context) => AuthModel(),
        ),
        ChangeNotifierProvider<UserProvider>( // Add UserProvider here
          create: (context) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Doctor App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Pre-define input decoration
          inputDecorationTheme: const InputDecorationTheme(
            focusColor: Config.primaryColor,
            border: Config.outlinedBorder,
            focusedBorder: Config.focusBorder,
            errorBorder: Config.errorBorder,
            enabledBorder: Config.outlinedBorder,
            floatingLabelStyle: TextStyle(color: Config.primaryColor),
            prefixIconColor: Colors.black38,
          ),
          scaffoldBackgroundColor: Colors.white,
          // bottomNavigationBarTheme: BottomNavigationBarThemeData(
          //   backgroundColor: Config.primaryColor,
          //   selectedItemColor: Colors.white,
          //   showSelectedLabels: true,
          //   showUnselectedLabels: false,
          //   unselectedItemColor: Colors.grey.shade700,
          //   elevation: 10,
          //   type: BottomNavigationBarType.fixed,
          // ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthPage(),
          'main': (context) => const MainLayout(),
          'doc_detail': (context) => const DoctorDetails(),
          'booking_page': (context) => const BookingPage(),
          'success_booking': (context) => const AppointmentBooked(),
        },
      ),
    );
  }
}

import 'package:homecareapp/main_layout.dart';
import 'package:homecareapp/models/auth_model.dart';
import 'package:homecareapp/screens/auth_page.dart';
import 'package:homecareapp/screens/tanggal_page.dart';
import 'package:homecareapp/screens/success_booked.dart';
import 'package:homecareapp/screens2/home_doc.dart'; // Import the home_doc.dart
import 'package:homecareapp/utils/config.dart';
import 'package:homecareapp/screens/konsultas_booking.dart';
import 'package:homecareapp/screens2/detail_user.dart';
import 'package:homecareapp/screens2/soap_page.dart';
import 'package:homecareapp/screens2/view_medrec.dart';
import 'package:homecareapp/screen3/admisi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthModel>(
      create: (context) => AuthModel(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Flutter Doctor App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
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
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Config.primaryColor,
            selectedItemColor: Colors.white,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            unselectedItemColor: Colors.grey.shade700,
            elevation: 10,
            type: BottomNavigationBarType.fixed,
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthPage(),
          'main': (context) => const MainLayout(),
          'tanggal_page': (context) => TanggalWaktu(),
          'success_booking': (context) => const AppointmentBooked(),
          'doc_dashboard': (context) => DocDash(), // Add the route for doctor dashboard
          'konsultasi': (context) => const KonsultasiBooking(),
          'admisi_das': (context) => AdmisiPage(),
          'detail_user': (context) => DetailUser(schedule: ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>),
          'soap_menu': (context) => SoapPage(schedule: ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>),
          'view_medrec': (context) => ViewMedRec(soapData: ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>),
        },
      ),
    );
  }
}

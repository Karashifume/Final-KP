import 'package:homecareapp/main_layout.dart';
import 'package:homecareapp/models/auth_model.dart';
import 'package:homecareapp/screens/auth_page.dart';
import 'package:homecareapp/screens/tanggal_page.dart';
import 'package:homecareapp/screens2/home_doc.dart';
import 'package:homecareapp/utils/config.dart';
import 'package:homecareapp/screens/konsultasi_booking.dart';
import 'package:homecareapp/screens2/detail_user.dart';
import 'package:homecareapp/screens2/soap_page.dart';
import 'package:homecareapp/screens2/view_medrec.dart';
import 'package:homecareapp/screen3/admisi.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
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
        title: 'HomeCare',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            focusColor: Color.fromRGBO(116, 225, 225, 1),
            border: Config.outlinedBorder,
            focusedBorder: Config.focusBorder,
            errorBorder: Config.errorBorder,
            enabledBorder: Config.outlinedBorder,
            floatingLabelStyle: TextStyle(color: Color.fromRGBO(116, 225, 225, 1)),
            prefixIconColor: Colors.black38,
          ),
          scaffoldBackgroundColor: Colors.white,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Color.fromRGBO(116, 225, 225, 1),
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
          'doc_dashboard': (context) => const DocDash(),
          'konsultasi': (context) => const KonsultasiBooking(),
          'admisi_das': (context) => AdmisiPage(),
          'detail_user': (context) => DetailUser(schedule: ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>),
          'soap_menu': (context) => SoapPage(schedule: ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>),
          'view_medrec': (context) => ViewMedRec(appointmentId: ModalRoute.of(context)?.settings.arguments as int),
        },
      ),
    );
  }
}

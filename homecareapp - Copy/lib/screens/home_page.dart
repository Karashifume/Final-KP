import 'package:flutter/material.dart';
import 'package:homecareapp/screens/insert_ktp.dart';
import 'package:homecareapp/screens/profile_page.dart'; // Added import for ProfilePage
import 'package:homecareapp/utils/config.dart';
import 'package:homecareapp/data/ktp_data.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:homecareapp/screens/Waktu.dart';
import 'package:homecareapp/screens/Booking.dart';
import 'package:homecareapp/screens/appointment_page.dart';
import 'package:provider/provider.dart';
import 'package:homecareapp/data/user_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isKtpVerified = false;

  @override
  void initState() {
    super.initState();
    _loadKtpData();
  }

  Future<void> _loadKtpData() async {
    if (kIsWeb) {
      String? base64Image = await KtpData.getImageBase64();
      if (base64Image != null) {
        setState(() {
          _isKtpVerified = true;
        });
      }
    } else {
      String? imagePath = await KtpData.getImagePath();
      if (imagePath != null) {
        setState(() {
          _isKtpVerified = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Image.asset(
                      'assets/logorsmh.jpg',
                      width: 50,
                      height: 50,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfilePage()),
                        );
                      },
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/person.jpg'),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF69F0AE)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Pengisian Data',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF69F0AE),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Name: ${userProvider.userName}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'KTP Status: ${_isKtpVerified ? "Verified" : "Not Verified"}',
                          style: TextStyle(
                            fontSize: 18,
                            color: _isKtpVerified ? Color(0xFF69F0AE) : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InsertKtp()),
                            );
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFF69F0AE),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text('Foto Ktp'),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookingPage()),
                            );
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFF69F0AE),
                            child: Icon(
                              Icons.local_hospital,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text('Konsultasi'),
                      ],
                    ),
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AppointmentPage()),
                            );
                          },
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xFF69F0AE),
                            child: Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text('Jadwal'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

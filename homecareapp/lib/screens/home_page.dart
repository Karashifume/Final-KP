import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:homecareapp/components/doctor_card.dart';
import 'package:homecareapp/data/ktp_data.dart';
import 'package:homecareapp/models/auth_model.dart';
import 'package:homecareapp/screens/konsultas_booking.dart';
import 'package:homecareapp/screens/appointment_page.dart';
import 'package:homecareapp/utils/config.dart';
import 'package:homecareapp/screens/insert_ktp.dart';
import 'package:flutter/material.dart';
import 'package:homecareapp/providers/dio_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic> user = {};
  Map<String, dynamic> doctor = {};
  List<dynamic> favList = [];
  bool _isKtpVerified = false;

  @override
  void initState() {
    super.initState();
    _loadKtpData();
  }

  Future<void> _loadKtpData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await DioProvider().getUser(token); // Get user data
    user = jsonDecode(response);
    
    if (user['ktp'] != null) {
      setState(() {
        _isKtpVerified = true;
      });
    } else {
      setState(() {
        _isKtpVerified = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    user = Provider.of<AuthModel>(context, listen: false).getUser;
    doctor = Provider.of<AuthModel>(context, listen: false).getAppointment;
    favList = Provider.of<AuthModel>(context, listen: false).getFav;

    return Scaffold(
      //if user is empty, then return progress indicator
      body: user.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
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
                                user['name'],
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 20),
                              Text(
                                _isKtpVerified
                                    ? 'KTP Status: Foto Ktp Telah Di Simpan'
                                    : 'KTP Status: Foto Ktp belum di masukkan',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: _isKtpVerified
                                      ? Color(0xFF69F0AE)
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20), // Add space here
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
                                        builder: (context) => KonsultasiBooking()),
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
                          // Column(
                          //   children: [
                          //     GestureDetector(
                          //       onTap: () {
                          //         Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) =>
                          //                   AppointmentPage()),
                          //         );
                          //       },
                          //       child: CircleAvatar(
                          //         radius: 30,
                          //         backgroundColor: Color(0xFF69F0AE),
                          //         child: Icon(
                          //           Icons.calendar_today,
                          //           color: Colors.white,
                          //         ),
                          //       ),
                          //     ),
                          //     SizedBox(height: 10),
                          //     Text('Jadwal'),
                          //   ],
                          // ),
                        ],
                      ),
                      Config.spaceSmall,
                      const Text(
                        'Top Doctors',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Config.spaceSmall,
                      Column(
                        children: List.generate(
                          user['doctor'].length > 10 ? 10 : user['doctor'].length,
                          (index) {
                            return DoctorCard(
                              doctor: user['doctor'][index],
                              //if lates fav list contains particular doctor id, then show fav icon
                              isFav: favList.contains(user['doctor'][index]['doc_id']),
                              isClickable: false, // Disable clickable for homepage
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

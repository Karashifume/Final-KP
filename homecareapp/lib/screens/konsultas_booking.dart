import 'package:flutter/material.dart';
import 'package:homecareapp/components/doctor_card.dart';
import 'package:homecareapp/screens/doctor_list.dart';
import 'package:homecareapp/utils/config.dart';
import 'package:homecareapp/screens/booking_page.dart';

class KonsultasiBooking extends StatefulWidget {
  const KonsultasiBooking({Key? key}) : super(key: key);

  @override
  _KonsultasiBookingPageState createState() => _KonsultasiBookingPageState();
}

class _KonsultasiBookingPageState extends State<KonsultasiBooking> {
  final _keluhanController = TextEditingController();
  final _alamatController = TextEditingController();
  Map<String, dynamic>? selectedDoctor;
  String? selectedDate;
  String? selectedDay;
  String? selectedTime;

  void _showConsultationPopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Mohon Tunggu'),
          content: Text('Permintaan Konsultasi Anda Sedang Di Verifikasi'),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
                Navigator.of(context).pushReplacementNamed('main'); // Navigate to 'main'
              },
            ),
          ],
        );
      },
    );
  }

  void _selectDoctor(Map<String, dynamic> doctor) {
    setState(() {
      selectedDoctor = doctor;
    });
  }

  void _selectTime(Map<String, String> timeDetails) {
    setState(() {
      selectedDate = timeDetails['date'];
      selectedDay = timeDetails['day'];
      selectedTime = timeDetails['time'];
    });
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    if (arguments != null) {
      final doctor = arguments['doctor'];
      final isFav = arguments['isFav'] ?? false;
      selectedDoctor = doctor;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF69F0AE),
        title: Text('Konsultasi Booking'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF69F0AE)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Keluhan / Permintaan',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF69F0AE),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _keluhanController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Tulis keluhan atau permintaan anda disini...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorList()),
                );
                if (result != null) {
                  _selectDoctor(result);
                }
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF69F0AE)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Dokter',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            if (selectedDoctor != null)
              DoctorCard(doctor: selectedDoctor!, isFav: arguments?['isFav'] ?? false),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingPage()),
                );
                if (result != null) {
                  _selectTime(result);
                }
              },
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF69F0AE)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Tanggal & Waktu',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            if (selectedDate != null && selectedTime != null)
              Text(
                'Tanggal yang Dipilih: $selectedDate ($selectedDay) \nWaktu yang Dipilih: $selectedTime',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF69F0AE)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Alamat',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF69F0AE),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _alamatController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Tulis alamat anda disini...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFF69F0AE)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Harga: Rp.250.000',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF69F0AE),
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                ),
                onPressed: _showConsultationPopup,
                child: Text(
                  'Konsultasi',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

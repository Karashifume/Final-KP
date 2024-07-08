import 'package:flutter/material.dart';
import 'package:homecareapp/components/doctor_card.dart';
import 'package:homecareapp/screens/doctor_list.dart';
import 'package:homecareapp/utils/config.dart';
import 'package:homecareapp/screens/tanggal_page.dart';
import 'package:homecareapp/providers/dio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KonsultasiBooking extends StatefulWidget {
  const KonsultasiBooking({Key? key}) : super(key: key);

  @override
  _KonsultasiTanggalWaktuState createState() => _KonsultasiTanggalWaktuState();
}

class _KonsultasiTanggalWaktuState extends State<KonsultasiBooking> {
  final _keluhanController = TextEditingController();
  final _alamatController = TextEditingController();
  Map<String, dynamic>? selectedDoctor;
  String? selectedDate;
  String? selectedDay;
  String? selectedTime;
  String? selectedHarga;

  final List<int> hargaList = [250000, 500000, 750000, 1000000];

  void _showConsultationPopup(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notifikasi'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
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

  Future<void> _bookAppointment() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    if (_keluhanController.text.isEmpty ||
        selectedDoctor == null ||
        selectedDate == null ||
        selectedTime == null ||
        _alamatController.text.isEmpty ||
        selectedHarga == null) {
      _showConsultationPopup('Semua kolom harus diisi.');
      return;
    }

    final result = await DioProvider().bookAppointment(
      selectedDate!,
      selectedDay!,
      selectedTime!,
      selectedDoctor!['doc_id'],
      _keluhanController.text,
      _alamatController.text,
      token,
      selectedHarga!,
    );

    if (result == 200) {
      Navigator.of(context).pushReplacementNamed('main');
    } else {
      _showConsultationPopup('Terjadi kesalahan saat memesan konsultasi.');
    }
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    final arguments = ModalRoute.of(context)?.settings.arguments as Map?;
    if (arguments != null) {
      final doctor = arguments['doctor'];
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
                    Icon(Icons.arrow_forward_outlined),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            if (selectedDoctor != null)
              DoctorCard(
                doctor: selectedDoctor!,
                isFav: arguments?['isFav'] ?? false,
                showSelectButton: false, // Hide the select button here
              ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TanggalWaktu()),
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
                    Icon(Icons.arrow_forward_outlined),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Harga Service',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF69F0AE),
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<int>(
                    value: selectedHarga != null ? int.parse(selectedHarga!) : null,
                    hint: Text('Pilih Harga'),
                    isExpanded: true,
                    items: hargaList.map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('Rp. $value'),
                      );
                    }).toList(),
                    onChanged: (int? newValue) {
                      setState(() {
                        selectedHarga = newValue.toString();
                      });
                    },
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
                onPressed: _bookAppointment,
                child: Text(
                  'Pesan Konsultasi',
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

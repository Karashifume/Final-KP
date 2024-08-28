import 'package:flutter/foundation.dart';
import 'package:homecareapp/components/doctor_card.dart';
import 'package:homecareapp/data/ktp_data.dart';
import 'package:homecareapp/models/auth_model.dart';
import 'package:homecareapp/screens/konsultasi_booking.dart';
import 'package:homecareapp/utils/config.dart';
import 'package:homecareapp/screens/insert_ktp.dart';
import 'package:flutter/material.dart';
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
  String searchQuery = '';
  String selectedCategory = 'All';
  String sortBy = 'doctor_name';
  bool sortAscending = true;
  List<dynamic> favList = [];
  bool _isKtpVerified = false;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _loadKtpData();
  }

  Future<void> _loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
    });
  }

  Future<void> _loadKtpData() async {
    String? imagePath = await KtpData.getImagePath();
    String? base64Image = await KtpData.getImageBase64();

    setState(() {
      _isKtpVerified = imagePath != null || base64Image != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    user = Provider.of<AuthModel>(context, listen: false).getUser;
    doctor = Provider.of<AuthModel>(context, listen: false).getAppointment;
    favList = Provider.of<AuthModel>(context, listen: false).getFav;

    // cek apakah dokter itu null atau tidak
    final List<dynamic> doctorsList = user['doctor'] ?? [];

    // filter dan sorting berdasarkan categogry, search.
    List<dynamic> filteredDoctors = doctorsList.where((doctor) {
      final String doctorName = doctor['doctor_name'] ?? '';
      final String category = doctor['category'] ?? '';
      return (doctorName.toLowerCase().contains(searchQuery.toLowerCase()) ||
              category.toLowerCase().contains(searchQuery.toLowerCase())) &&
          (selectedCategory == 'All' || category == selectedCategory);
    }).toList();

    filteredDoctors.sort((a, b) {
      int compare;
      if (sortBy == 'doctor_name') {
        compare = a['doctor_name'].compareTo(b['doctor_name']);
      } else {
        compare = (a['harga'] as int).compareTo(b['harga'] as int);
      }
      return sortAscending ? compare : -compare;
    });

    return Scaffold(
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
                            border: Border.all(color: Color.fromRGBO(116, 225, 225, 1)),
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
                                  color: Color.fromRGBO(116, 225, 225, 1),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                user['name'] ?? '',
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
                                      ? Color.fromRGBO(116, 225, 225, 1)
                                      : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
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
                                  ).then((_) {
                                    _loadKtpData();
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: Color.fromRGBO(116, 225, 225, 1),
                                  child: Icon(
                                    Icons.photo_library,
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
                                onTap: _isKtpVerified
                                    ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  KonsultasiBooking()),
                                        );
                                      }
                                    : null,
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundColor: _isKtpVerified
                                      ? Color.fromRGBO(116, 225, 225, 1)
                                      : Colors.grey,
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
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Search',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  searchQuery = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              value: selectedCategory,
                              items: [
                                'All',
                                ...doctorsList
                                    .map<String>((doctor) => doctor['category'])
                                    .toSet()
                              ].map<DropdownMenuItem<String>>((dynamic value) {
                                return DropdownMenuItem<String>(
                                  value: value as String,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value!;
                                });
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.sort),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setStateDialog) {
                                      return AlertDialog(
                                        title: Text('Urutkan Berdasarkan'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              title: Text('Doctor Name'),
                                              leading: Radio<String>(
                                                value: 'doctor_name',
                                                groupValue: sortBy,
                                                onChanged: (value) {
                                                  setStateDialog(() {
                                                    sortBy = value!;
                                                  });
                                                  setState(() {}); // Update "main state"
                                                },
                                              ),
                                            ),
                                            ListTile(
                                              title: Text('Harga'),
                                              leading: Radio<String>(
                                                value: 'harga',
                                                groupValue: sortBy,
                                                onChanged: (value) {
                                                  setStateDialog(() {
                                                    sortBy = value!;
                                                  });
                                                  setState(() {}); // Update "main state"
                                                },
                                              ),
                                            ),
                                            SwitchListTile(
                                              title: Text('Dari Terkecil'),
                                              value: sortAscending,
                                              onChanged: (value) {
                                                setStateDialog(() {
                                                  sortAscending = value;
                                                });
                                                setState(() {}); // Update "main state"
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Close'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      Config.spaceSmall,
                      Column(
                        children: List.generate(
                          filteredDoctors.length,
                          (index) {
                            return DoctorCard(
                              doctor: filteredDoctors[index],
                              isFav: favList.contains(
                                filteredDoctors[index]['doc_id'],
                              ),
                              showSelectButton: false,
                              isClickable: false,
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

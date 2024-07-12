import 'package:flutter/foundation.dart';
import 'package:homecareapp/components/doctor_card.dart';
import 'package:homecareapp/models/auth_model.dart';
import 'package:homecareapp/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DoctorList extends StatefulWidget {
  const DoctorList({Key? key}) : super(key: key);

  @override
  State<DoctorList> createState() => _DoctorListState();
}

class _DoctorListState extends State<DoctorList> {
  Map<String, dynamic> user = {};
  Map<String, dynamic> doctor = {};
  List<dynamic> favList = [];
  String searchQuery = '';
  String selectedCategory = 'All';
  String sortBy = 'doctor_name';
  bool sortAscending = true;

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    user = Provider.of<AuthModel>(context, listen: false).getUser;
    doctor = Provider.of<AuthModel>(context, listen: false).getAppointment;
    favList = Provider.of<AuthModel>(context, listen: false).getFav;

    // Check if user['doctor'] is null and handle accordingly
    final List<dynamic> doctorsList = user['doctor'] ?? [];

    // Filter and sort doctorsList based on search, category, and sort criteria
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
      appBar: AppBar(
        backgroundColor: Color(0xFF69F0AE),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
                                    builder: (context, setState) {
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
                                                  setState(() {
                                                    sortBy = value!;
                                                  });
                                                },
                                              ),
                                            ),
                                            ListTile(
                                              title: Text('Harga'),
                                              leading: Radio<String>(
                                                value: 'harga',
                                                groupValue: sortBy,
                                                onChanged: (value) {
                                                  setState(() {
                                                    sortBy = value!;
                                                  });
                                                },
                                              ),
                                            ),
                                            SwitchListTile(
                                              title: Text('Dari Terkecil'),
                                              value: sortAscending,
                                              onChanged: (value) {
                                                setState(() {
                                                  sortAscending = value;
                                                });
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
                              isClickable: true,
                              showSelectButton: true, // Show the select button here
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

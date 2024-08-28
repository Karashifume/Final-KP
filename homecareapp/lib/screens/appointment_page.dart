import 'package:flutter/material.dart';
import 'package:homecareapp/providers/dio_provider.dart';
import 'package:homecareapp/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'reschedule_page.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({Key? key}) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

enum FilterStatus { upcoming, complete, cancel }

class _AppointmentPageState extends State<AppointmentPage> {
  FilterStatus status = FilterStatus.upcoming;
  Alignment _alignment = Alignment.centerLeft;
  List<dynamic> schedules = [];
  String searchQuery = '';
  String selectedCategory = 'All';
  String sortBy = 'doctor_name';
  bool sortAscending = true;

  Future<void> getAppointments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final appointment = await DioProvider().getAppointments(token);
    if (appointment != 'Error') {
      setState(() {
        schedules = json.decode(appointment);
      });
    }
  }

  @override
  void initState() {
    getAppointments();
    super.initState();
  }

  void _showAlasanDialog(String? alasan) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Lihat Alasan'),
          content: Text(alasan ?? 'Belum ada Alasan'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (BuildContext context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final String token = snapshot.data?.getString('token') ?? '';

        List<dynamic> filteredSchedules = schedules.where((var schedule) {
          return schedule['status'] == status.name &&
              (schedule['doctor_name'].toLowerCase().contains(searchQuery.toLowerCase()) ||
                  schedule['category'].toLowerCase().contains(searchQuery.toLowerCase())) &&
              (selectedCategory == 'All' || schedule['category'] == selectedCategory);
        }).toList();

        filteredSchedules.sort((a, b) {
          int compare;
          if (sortBy == 'doctor_name') {
            compare = a['doctor_name'].compareTo(b['doctor_name']);
          } else {
            compare = (a['harga'] as int).compareTo(b['harga'] as int);
          }
          return sortAscending ? compare : -compare;
        });

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Riwayat Konsultasi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
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
                          ...schedules
                              .map<String>((schedule) => schedule['category'])
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
                                            this.setState(() {}); // Update the main state
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
                                            this.setState(() {}); // Update the main state
                                          },
                                        ),
                                      ),
                                      SwitchListTile(
                                        title: Text('Ascending'),
                                        value: sortAscending,
                                        onChanged: (value) {
                                          setState(() {
                                            sortAscending = value;
                                          });
                                          this.setState(() {}); // Update the main state
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
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          for (FilterStatus filterStatus in FilterStatus.values)
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    status = filterStatus;
                                    if (filterStatus == FilterStatus.upcoming) {
                                      _alignment = Alignment.centerLeft;
                                    } else if (filterStatus == FilterStatus.complete) {
                                      _alignment = Alignment.center;
                                    } else if (filterStatus == FilterStatus.cancel) {
                                      _alignment = Alignment.centerRight;
                                    }
                                  });
                                },
                                child: Center(
                                  child: Text(
                                    filterStatus.name,
                                    style: TextStyle(
                                      fontWeight: status == filterStatus ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    AnimatedAlign(
                      alignment: _alignment,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(116, 225, 225, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            status.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Config.spaceSmall,
                filteredSchedules.isEmpty
                    ? const Center(child: Text('No appointments available'))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: filteredSchedules.length,
                          itemBuilder: ((context, index) {
                            var schedule = filteredSchedules[index];
                            bool isLastElement = filteredSchedules.length + 1 == index;
                            return Card(
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              margin: !isLastElement ? const EdgeInsets.only(bottom: 20) : EdgeInsets.zero,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: NetworkImage("http://127.0.0.1:8000${schedule['doctor_profile']}"),
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              schedule['doctor_name'],
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              schedule['category'],
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    ScheduleCard(
                                      date: schedule['date'],
                                      day: schedule['day'],
                                      time: schedule['time'],
                                    ),
                                    const SizedBox(height: 15),
                                    if (schedule['status'] == 'cancel')
                                      OutlinedButton(
                                        onPressed: () {
                                          _showAlasanDialog(schedule['alasan']);
                                        },
                                        child: const Text('Lihat Alasan'),
                                      ),
                                    if (schedule['status'] == 'upcoming') ...[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () async {
                                                await DioProvider().updateAppointmentStatus(schedule['id'], 'cancel', token);
                                                getAppointments();
                                              },
                                              child: const Text(
                                                'Cancel',
                                                style: TextStyle(color: Color.fromRGBO(116, 225, 225, 1)),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: OutlinedButton(
                                              style: OutlinedButton.styleFrom(
                                                backgroundColor: const Color.fromRGBO(116, 225, 225, 1),
                                              ),
                                              onPressed: () async {
                                                final result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => ReschedulePage(appointmentId: schedule['id']),
                                                  ),
                                                );
                                                if (result != null) {
                                                  final newDate = result['date'];
                                                  final newDay = result['day'];
                                                  final newTime = result['time'];

                                                  await DioProvider().updateAppointmentDetails(
                                                    schedule['id'],
                                                    newDate,
                                                    newDay,
                                                    newTime,
                                                    token,
                                                  );
                                                  getAppointments();
                                                }
                                              },
                                              child: const Text(
                                                'Reschedule',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ] else if (schedule['status'] == 'complete') ...[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                  context,
                                                  'view_medrec',
                                                  arguments: schedule['id'],
                                                );
                                              },
                                              child: const Text(
                                                'Lihat Hasil Diagnosa',
                                                style: TextStyle(color: Color.fromRGBO(116, 225, 225, 1)),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({Key? key, required this.date, required this.day, required this.time}) : super(key: key);
  final String date;
  final String day;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Icon(
            Icons.calendar_today,
            color: Color.fromRGBO(116, 225, 225, 1),
            size: 15,
          ),
          const SizedBox(width: 5),
          Text(
            '$day, $date',
            style: const TextStyle(
              color: Color.fromRGBO(116, 225, 225, 1),
            ),
          ),
          const SizedBox(width: 20),
          const Icon(
            Icons.access_alarm,
            color: Color.fromRGBO(116, 225, 225, 1),
            size: 17,
          ),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              time,
              style: const TextStyle(
                color: Color.fromRGBO(116, 225, 225, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

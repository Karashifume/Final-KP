import 'package:flutter/material.dart';
import 'package:homecareapp/providers/dio_provider.dart';
import 'package:homecareapp/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:homecareapp/screens/profile_page.dart';
import 'dart:convert';

class DocDash extends StatefulWidget {
  const DocDash({Key? key}) : super(key: key);

  @override
  State<DocDash> createState() => _DocDashState();
}

//enum for appointment status
enum FilterStatus { upcoming, complete, cancel }

class _DocDashState extends State<DocDash> {
  FilterStatus status = FilterStatus.upcoming; //initial status
  Alignment _alignment = Alignment.centerLeft;
  List<dynamic> schedules = [];

  //get appointments details
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
          return schedule['status'] == status.name;
        }).toList();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Config.primaryColor,
            title: const Text(''),
            leading: IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(),
                  ),
                );
              },
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
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
                                        fontSize: 14, // Reduced font size
                                        fontWeight: status == filterStatus
                                            ? FontWeight.bold
                                            : FontWeight.normal,
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
                            color: Config.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              status.name,
                              style: const TextStyle(
                                fontSize: 14, // Reduced font size
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
                                margin: !isLastElement
                                    ? const EdgeInsets.only(bottom: 20)
                                    : EdgeInsets.zero,
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                "http://127.0.0.1:8000${schedule['pasien_profile']}"),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                schedule['pasien_name'],
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
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
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      ScheduleCard(
                                        date: schedule['date'],
                                        day: schedule['day'],
                                        time: schedule['time'],
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      if (schedule['status'] != 'complete' && schedule['status'] != 'cancel')
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    'detail_user',
                                                    arguments: schedule,
                                                  );
                                                },
                                                child: const Text(
                                                  'Detail User',
                                                  style: TextStyle(color: Config.primaryColor),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Expanded(
                                              child: OutlinedButton(
                                                style: OutlinedButton.styleFrom(
                                                  backgroundColor: Config.primaryColor,
                                                ),
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                    context,
                                                    'soap_menu',
                                                    arguments: schedule,
                                                  ).then((value) async {
                                                    await DioProvider().updateAppointmentStatus(schedule['id'], 'complete', token);
                                                    getAppointments();
                                                  });
                                                },
                                                child: Text(
                                                  schedule['status'] == 'complete'
                                                      ? 'Edit SOAP'
                                                      : 'Insert SOAP',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
            color: Config.primaryColor,
            size: 15,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            '$day, $date',
            style: const TextStyle(
              color: Config.primaryColor,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(
            Icons.access_alarm,
            color: Config.primaryColor,
            size: 17,
          ),
          const SizedBox(
            width: 5,
          ),
          Flexible(
              child: Text(
            time,
            style: const TextStyle(
              color: Config.primaryColor,
            ),
          ))
        ],
      ),
    );
  }
}

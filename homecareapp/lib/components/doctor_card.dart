import 'package:homecareapp/screens/doctor_details.dart';
import 'package:homecareapp/utils/config.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    Key? key,
    required this.doctor,
    required this.isFav,
    this.isClickable = true,
    this.showSelectButton = true, // Added this parameter
  }) : super(key: key);

  final Map<String, dynamic> doctor;
  final bool isFav;
  final bool isClickable;
  final bool showSelectButton; // Added this field

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 150,
      child: Card(
        elevation: 5,
        color: Colors.white,
        child: Row(
          children: [
            // Profile Dokter Button
            IconButton(
              icon: Icon(Icons.info),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DoctorDetails(
                      doctor: doctor,
                      isFav: isFav,
                    ),
                  ),
                );
              },
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${doctor['doctor_name']}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${doctor['category']}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const <Widget>[
                        Icon(
                          Icons.star_border,
                          color: Colors.yellow,
                          size: 16,
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Text('4.5'),
                        Spacer(
                          flex: 1,
                        ),
                        Text('Reviews'),
                        Spacer(
                          flex: 1,
                        ),
                        Text('(20)'),
                        Spacer(
                          flex: 7,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Select Doctor Button
            if (showSelectButton) // Show the button conditionally
              IconButton(
                icon: Icon(Icons.check_circle),
                onPressed: isClickable
                    ? () {
                        Navigator.pop(context, doctor);
                      }
                    : null,
              ),
          ],
        ),
      ),
    );
  }
}

import 'package:homecareapp/screens/doctor_details.dart';
import 'package:homecareapp/utils/config.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({
    Key? key,
    required this.doctor,
    required this.isFav,
    this.isClickable = true,
    this.showSelectButton = true,
  }) : super(key: key);

  final Map<String, dynamic> doctor;
  final bool isFav;
  final bool isClickable;
  final bool showSelectButton;

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
                      children: <Widget>[
                        Text(
                          'Harga: ',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(flex: 1),
                        Text(
                          'Rp. ${doctor['harga']}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(flex: 7),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Select Doctor Button
            if (showSelectButton)
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

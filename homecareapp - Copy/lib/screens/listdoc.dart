import 'package:flutter/material.dart';
import 'package:homecareapp/components/doctor_card.dart';
import 'package:homecareapp/utils/config.dart';

class ListDoctor extends StatelessWidget {
  const ListDoctor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Config().init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF69F0AE),
        title: Text('List Dokter'),
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
          children: List.generate(10, (index) {
            return DoctorCard(
            );
          }),
        ),
      ),
    );
  }
}

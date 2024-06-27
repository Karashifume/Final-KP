import 'package:flutter/material.dart';
import 'package:homecareapp/utils/config.dart';

class DetailUser extends StatelessWidget {
  final Map<String, dynamic> schedule;

  const DetailUser({Key? key, required this.schedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config.primaryColor,
        title: const Text('User Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DetailBox(title: 'Pasien Name', content: schedule['pasien_name']),
            DetailBox(title: 'Keluhan', content: schedule['keluhan']),
            DetailBox(title: 'Date', content: schedule['date']),
            DetailBox(title: 'Day', content: schedule['day']),
            DetailBox(title: 'Time', content: schedule['time']),
            DetailBox(title: 'Alamat', content: schedule['alamat']),
            DetailBox(title: 'Harga', content: 'Rp.250.000'),
          ],
        ),
      ),
    );
  }
}

class DetailBox extends StatelessWidget {
  final String title;
  final String content;

  const DetailBox({Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Config.primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Config.primaryColor,
            ),
          ),
          SizedBox(height: 5),
          Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:homecareapp/utils/config.dart';
import 'package:homecareapp/providers/dio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class DetailUser extends StatefulWidget {
  final Map<String, dynamic> schedule;

  const DetailUser({Key? key, required this.schedule}) : super(key: key);

  @override
  _DetailUserState createState() => _DetailUserState();
}

class _DetailUserState extends State<DetailUser> {
  Map<String, dynamic>? pasienDetails;

  @override
  void initState() {
    super.initState();
    _loadPasienDetails();
  }

  Future<void> _loadPasienDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await DioProvider().getPasienDetails(token, widget.schedule['user_id']);
    if (response.statusCode == 200) {
      setState(() {
        pasienDetails = json.decode(response.data);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load user details'),
      ));
    }
  }

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
            DetailBox(title: 'Pasien Name', content: widget.schedule['pasien_name']),
            DetailBox(title: 'Keluhan', content: widget.schedule['keluhan']),
            DetailBox(title: 'Date', content: widget.schedule['date']),
            DetailBox(title: 'Day', content: widget.schedule['day']),
            DetailBox(title: 'Time', content: widget.schedule['time']),
            DetailBox(title: 'Alamat', content: widget.schedule['alamat']),
            DetailBox(title: 'Harga', content: 'Rp.250.000'),
            const Divider(),
            if (pasienDetails != null) ...[
              DetailBox(title: 'NIK', content: pasienDetails!['nik']),
              DetailBox(title: 'Nama Asli', content: pasienDetails!['nama_asli']),
              DetailBox(title: 'Tanggal Lahir', content: pasienDetails!['tgl_lahir']),
              DetailBox(title: 'Alamat', content: pasienDetails!['alamat']),
              DetailBox(title: 'Agama', content: pasienDetails!['agama']),
              DetailBox(title: 'Pekerjaan', content: pasienDetails!['perkerjaan']),
            ] else
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}

class DetailBox extends StatelessWidget {
  final String title;
  final String content;

  const DetailBox({Key? key, required this.title, required this.content}) : super(key: key);

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

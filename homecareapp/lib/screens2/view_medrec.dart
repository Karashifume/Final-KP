import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:homecareapp/providers/dio_provider.dart';
import 'package:homecareapp/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewMedRec extends StatefulWidget {
  final int appointmentId;

  const ViewMedRec({Key? key, required this.appointmentId}) : super(key: key);

  @override
  _ViewMedRecState createState() => _ViewMedRecState();
}

class _ViewMedRecState extends State<ViewMedRec> {
  Map<String, dynamic>? soapData;

  @override
  void initState() {
    super.initState();
    _loadSoapData();
  }

  Future<void> _loadSoapData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final soap = await DioProvider().getSoap(widget.appointmentId, token);

    if (soap != 'Error') {
      setState(() {
        soapData = json.decode(soap);
      });
    } else {
      // Handle error
      print("Error fetching SOAP data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config.primaryColor,
        title: const Text('View Medical Record'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: soapData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SoapDetailBox(title: 'Subjective', content: soapData!['subjective']),
                  SoapDetailBox(title: 'Objective', content: soapData!['objective']),
                  SoapDetailBox(title: 'Assessment', content: soapData!['assessment']),
                  SoapDetailBox(title: 'Planning', content: soapData!['planning']),
                  SoapDetailBox(title: 'Resep', content: soapData!['resep']),
                ],
              ),
            ),
    );
  }
}

class SoapDetailBox extends StatelessWidget {
  final String title;
  final String content;

  const SoapDetailBox({Key? key, required this.title, required this.content}) : super(key: key);

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

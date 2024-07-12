import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:homecareapp/providers/dio_provider.dart';
import 'package:homecareapp/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoapPage extends StatefulWidget {
  final Map<String, dynamic> schedule;

  const SoapPage({Key? key, required this.schedule}) : super(key: key);

  @override
  _SoapPageState createState() => _SoapPageState();
}

class _SoapPageState extends State<SoapPage> {
  final _subjectiveController = TextEditingController();
  final _objectiveController = TextEditingController();
  final _assessmentController = TextEditingController();
  final _planningController = TextEditingController();
  final _resepController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSoapData();
  }

  Future<void> _loadSoapData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final soap = await DioProvider().getSoap(widget.schedule['id'], token);

    if (soap != 'Error') {
      final soapData = json.decode(soap);
      _subjectiveController.text = soapData['subjective'];
      _objectiveController.text = soapData['objective'];
      _assessmentController.text = soapData['assessment'];
      _planningController.text = soapData['planning'];
      _resepController.text = soapData['resep'];
    }
  }

  void _showPopup(String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissal by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notifikasi'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveSoap() async {
    if (_subjectiveController.text.isEmpty ||
        _objectiveController.text.isEmpty ||
        _assessmentController.text.isEmpty ||
        _planningController.text.isEmpty ||
        _resepController.text.isEmpty) {
      _showPopup('Ada Kotak Yang Belom Di Isi');
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final result = await DioProvider().saveSoap(
      widget.schedule['id'],
      _subjectiveController.text,
      _objectiveController.text,
      _assessmentController.text,
      _planningController.text,
      _resepController.text,
      token,
    );

    if (result == 200) {
      _showPopup('SOAP berhasil Disimpan');
      await DioProvider().updateAppointmentStatus(widget.schedule['id'], 'complete', token);
      Navigator.of(context).pushReplacementNamed('doc_dashboard');
    } else {
      _showPopup('Terjadi kesalahan saat menyimpan SOAP');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config.primaryColor,
        title: const Text('Insert SOAP'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SoapInputBox(controller: _subjectiveController, title: 'Subjective'),
            SoapInputBox(controller: _objectiveController, title: 'Objective'),
            SoapInputBox(controller: _assessmentController, title: 'Assessment'),
            SoapInputBox(controller: _planningController, title: 'Planning'),
            SoapInputBox(controller: _resepController, title: 'Resep'),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Config.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                ),
                onPressed: _saveSoap,
                child: Text(
                  'Simpan Medical Record',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SoapInputBox extends StatelessWidget {
  final TextEditingController controller;
  final String title;

  const SoapInputBox({Key? key, required this.controller, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Config.primaryColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Config.primaryColor,
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: controller,
            maxLines: null,
            decoration: InputDecoration(
              hintText: 'Tulis $title disini...',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
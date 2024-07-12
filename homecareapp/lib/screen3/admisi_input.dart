import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:homecareapp/data/ktp_data.dart';
import 'package:homecareapp/providers/dio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyUserPage extends StatefulWidget {
  final Map<String, dynamic> user;

  VerifyUserPage({required this.user});

  @override
  _VerifyUserPageState createState() => _VerifyUserPageState();
}

class _VerifyUserPageState extends State<VerifyUserPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nikController;
  late TextEditingController _namaAsliController;
  late TextEditingController _tglLahirController;
  late TextEditingController _alamatController;
  late TextEditingController _agamaController;
  late TextEditingController _pekerjaanController;
  Uint8List? _webImage;
  File? _image;

  @override
  void initState() {
    super.initState();
    _nikController = TextEditingController(text: widget.user['nik'] ?? '');
    _namaAsliController = TextEditingController(text: widget.user['nama_asli'] ?? '');
    _tglLahirController = TextEditingController(text: widget.user['tgl_lahir'] ?? '');
    _alamatController = TextEditingController(text: widget.user['alamat'] ?? '');
    _agamaController = TextEditingController(text: widget.user['agama'] ?? '');
    _pekerjaanController = TextEditingController(text: widget.user['perkerjaan'] ?? '');
    _loadKtpImage();
  }

  Future<void> _loadKtpImage() async {
    if (kIsWeb) {
      String? base64Image = await KtpData.getImageBase64();
      if (base64Image != null) {
        setState(() {
          _webImage = base64Decode(base64Image);
        });
      }
    } else {
      String? imagePath = await KtpData.getImagePath();
      if (imagePath != null) {
        setState(() {
          _image = File(imagePath);
        });
      }
    }
  }

  Future<void> _verifyUser() async {
    if (_formKey.currentState!.validate()) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await DioProvider().verifyUser(
        token,
        widget.user['user_id'],
        _nikController.text,
        _namaAsliController.text,
        _tglLahirController.text,
        _alamatController.text,
        _agamaController.text,
        _pekerjaanController.text,
      );

      if (response == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Verify user succeeded'),
        ));
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to verify user.'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify User - ${widget.user['user']['name']}'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_webImage != null)
                Image.memory(_webImage!)
              else if (_image != null)
                Image.file(_image!),
              SizedBox(height: 20),
              TextFormField(
                controller: _nikController,
                decoration: InputDecoration(labelText: 'NIK'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter NIK';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _namaAsliController,
                decoration: InputDecoration(labelText: 'Nama Asli'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Nama Asli';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tglLahirController,
                decoration: InputDecoration(labelText: 'Tanggal Lahir'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Tanggal Lahir';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Alamat';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _agamaController,
                decoration: InputDecoration(labelText: 'Agama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Agama';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _pekerjaanController,
                decoration: InputDecoration(labelText: 'Pekerjaan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Pekerjaan';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyUser,
                child: Text('Verify User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:homecareapp/providers/dio_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InsertKtp extends StatefulWidget {
  @override
  _InsertKtpState createState() => _InsertKtpState();
}

class _InsertKtpState extends State<InsertKtp> {
  File? _image;
  Uint8List? _webImage; // Store Uint8List for web

  final ImagePicker _picker = ImagePicker();

  Future<void> _requestPermission() async {
    if (!kIsWeb) {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Camera permission is required to capture images.'),
        ));
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      if (!kIsWeb) {
        await _requestPermission();
      }

      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        if (kIsWeb) {
          final bytes = await pickedFile.readAsBytes();
          setState(() {
            _webImage = bytes;
          });
        } else {
          final directory = await getApplicationDocumentsDirectory();
          final filePath = '${directory.path}/${pickedFile.name}';
          final file = File(filePath);
          await file.writeAsBytes(await pickedFile.readAsBytes());

          setState(() {
            _image = file;
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to pick image: $e'),
      ));
    }
  }

  Future<void> _saveImage() async {
    if (_image == null && _webImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No image to save.'),
      ));
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      var filePath = _image?.path ?? '';
      var result = await DioProvider().storeKtp(token, filePath);

      if (result == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('KTP has been saved successfully!'),
        ));
        Navigator.of(context).pushReplacementNamed('main');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save KTP.'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _requestPermission(); // Request permission on startup
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insert KTP'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_image == null && _webImage == null)
              Text('No image selected.')
            else if (kIsWeb && _webImage != null)
              Image.memory(_webImage!)
            else if (!kIsWeb && _image != null)
              Image.file(_image!),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.camera_alt, size: 50),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                SizedBox(width: 20),
                IconButton(
                  icon: Icon(Icons.photo_library, size: 50),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveImage,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

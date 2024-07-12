import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:homecareapp/data/ktp_data.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';

class InsertKtp extends StatefulWidget {
  @override
  _InsertKtpState createState() => _InsertKtpState();
}

class _InsertKtpState extends State<InsertKtp> {
  File? _image;
  Uint8List? _webImage; // Store Uint8List for web

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        if (kIsWeb) {
          // Handle web image
          final bytes = await pickedFile.readAsBytes();
          String base64Image = base64Encode(bytes);
          await KtpData.saveImageBase64(base64Image);

          setState(() {
            _webImage = bytes;
          });
        } else {
          // Handle mobile image
          final directory = await getApplicationDocumentsDirectory();
          final filePath = '${directory.path}/${pickedFile.name}';
          final file = File(filePath);
          await file.writeAsBytes(await pickedFile.readAsBytes());

          await KtpData.saveImagePath(filePath);

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

  @override
  void initState() {
    super.initState();
    _loadImage(); // Load saved image if any
  }

  Future<void> _loadImage() async {
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

  Future<void> _saveImage() async {
    // Save the image and navigate to the main page
    if (_image != null || _webImage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Foto Berhasil DiSimpan'),
      ));
      Navigator.of(context).pushReplacementNamed('main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No image to save.'),
      ));
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
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: Image.memory(
                  _webImage!,
                  fit: BoxFit.contain,
                ),
              )
            else if (!kIsWeb && _image != null)
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8,
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: Image.file(
                  _image!,
                  fit: BoxFit.contain,
                ),
              ),
            SizedBox(height: 20),
            IconButton(
              icon: Icon(Icons.photo_library, size: 50),
              onPressed: () => _pickImage(ImageSource.gallery),
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

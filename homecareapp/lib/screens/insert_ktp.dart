import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:homecareapp/providers/dio_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart';

class InsertKtp extends StatefulWidget {
  @override
  _InsertKtpState createState() => _InsertKtpState();
}

class _InsertKtpState extends State<InsertKtp> {
  File? _image;
  Uint8List? _webImage; // Store Uint8List for web
  String? _imageUrl; // Store image URL for web
  String? _token;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadToken();
    _loadImage();
  }

  Future<void> _loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
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
    if (_token == null) return;

    var response;
    if (kIsWeb && _webImage != null) {
      response = await DioProvider().storeKtp(_token!, '', webFile: _webImage);
    } else if (_image != null) {
      response = await DioProvider().storeKtp(_token!, _image!.path);
    }

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Image uploaded successfully!'),
      ));
      Navigator.of(context).pushReplacementNamed('main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to upload image.'),
      ));
    }
  }

  Future<void> _loadImage() async {
    if (_token == null) return;

    var response = await DioProvider().getKtp(_token!);

    if (response.statusCode == 200 && response.data != null) {
      setState(() {
        if (kIsWeb) {
          _imageUrl = response.data['ktp']; // This is a URL for the web
        } else {
          // Handle mobile case if necessary
        }
      });
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
            if (_image == null && _webImage == null && _imageUrl == null)
              Text('No image selected.')
            else if (kIsWeb && _webImage != null)
              Container(
                constraints: BoxConstraints(
                  maxWidth: 300.0, // Set maximum width
                  maxHeight: 300.0, // Set maximum height
                ),
                child: Image.memory(
                  _webImage!,
                  fit: BoxFit.contain,
                ),
              )
            else if (kIsWeb && _imageUrl != null)
              Container(
                constraints: BoxConstraints(
                  maxWidth: 300.0, // Set maximum width
                  maxHeight: 300.0, // Set maximum height
                ),
                child: Image.network(
                  _imageUrl!,
                  fit: BoxFit.contain,
                ),
              )
            else if (!kIsWeb && _image != null)
              Container(
                constraints: BoxConstraints(
                  maxWidth: 300.0, // Set maximum width
                  maxHeight: 300.0, // Set maximum height
                ),
                child: Image.file(
                  _image!,
                  fit: BoxFit.contain,
                ),
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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

import 'package:homecareapp/screen3/admisi_input.dart';
import 'package:flutter/material.dart';
import 'package:homecareapp/providers/dio_provider.dart';
import 'package:homecareapp/utils/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:homecareapp/screens/profile_page.dart';

class AdmisiPage extends StatefulWidget {
  @override
  _AdmisiPageState createState() => _AdmisiPageState();
}

class _AdmisiPageState extends State<AdmisiPage> {
  List<dynamic> unverifiedUsers = [];

  @override
  void initState() {
    super.initState();
    _getUnverifiedUsers();
  }

  Future<void> _getUnverifiedUsers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await DioProvider().getUnverifiedUsers(token);
    if (response != 'Error') {
      setState(() {
        unverifiedUsers = json.decode(response);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Config.primaryColor, // Changed navbar color
        title: Text('Admisi - Unverified Users'),
        automaticallyImplyLeading: false, // Remove default back button
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: unverifiedUsers.isEmpty
          ? Center(child: Text('No unverified users'))
          : ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: unverifiedUsers.length,
              itemBuilder: (context, index) {
                var user = unverifiedUsers[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.0),
                    title: Text(user['user']['name'] ?? 'No Name'),
                    subtitle: Text('NIK: ${user['nik'] ?? 'No NIK'}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyUserPage(user: user),
                        ),
                      ).then((_) {
                        _getUnverifiedUsers();
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}

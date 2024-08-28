import "package:homecareapp/main.dart";
import "package:homecareapp/utils/config.dart";
import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";

import "../providers/dio_provider.dart";

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(116, 225, 225, 1),
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color.fromRGBO(116, 225, 225, 1),
              child: Column(
                children: const <Widget>[
                  SizedBox(
                    height: 110,
                  ),
                  CircleAvatar(
                    radius: 65.0,
                    backgroundImage: AssetImage('assets/person.jpg'),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.grey[200],
              child: Center(
                child: Card(
                  margin: const EdgeInsets.fromLTRB(0, 45, 0, 0),
                  child: Container(
                    width: 300,
                    height: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Divider(
                            color: Colors.grey[300],
                          ),
                          Config.spaceSmall,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.logout_outlined,
                                color: Colors.lightGreen[400],
                                size: 35,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              TextButton(
                                onPressed: () async {
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  final token = prefs.getString('token') ?? '';

                                  if (token.isNotEmpty && token != '') {
                                    //logout here
                                    final response =
                                        await DioProvider().logout(token);

                                    if (response == 200) {
                                      //if successfully delete access token
                                      //then delete token saved at Shared Preference as well
                                      await prefs.remove('token');
                                      setState(() {
                                        //redirect to login page
                                        MyApp.navigatorKey.currentState!
                                            .pushReplacementNamed('/');
                                      });
                                    }
                                  }
                                },
                                child: const Text(
                                  "Logout",
                                  style: TextStyle(
                                    color: Color.fromRGBO(116, 225, 225, 1),
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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

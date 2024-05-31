// ignore_for_file: avoid_print, must_be_immutable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userName = 'محمد أمين';

  String userEmail = 'Ex@example.com';
  late String name;
  late String email;
  @override
  void initState() {
    super.initState();
    _getAuthName();
  }

  Future<void> _getAuthName() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      // Use the token for logout
      final url = Uri.parse('http://127.0.0.1:8000/api/user');
      final response = await http.post(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null && jsonData['data'] != null) {
          final data = jsonData['data'];

          name = data['name'];
          email = data['email'];

          print(data['name']);

          print(data['email']);
        }
        // print(jsonData);
      } else {
        print('failed to fetch user data');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: AndroidView(viewType: AutofillHints.birthday),
      backgroundColor: Colors.cyan[700],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('images/f.jpeg'),
              child: Icon(
                Icons.person,
                size: 60.0,
              ),
            ),
            Text(
              userName,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              '  مبرمج تطبيقات ويب وأندرويد  ',
              style: TextStyle(
                color: Color.fromARGB(255, 236, 232, 232),
                fontSize: 15,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
              width: 300,
              child: Divider(
                color: Colors.white,
              ),
            ),
            const Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: Icon(
                  Icons.phone,
                  color: Color.fromARGB(255, 28, 143, 32),
                ),
                title: Text(
                  '+967 770 914 610',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                leading: const Icon(
                  Icons.email,
                  color: Color.fromARGB(255, 243, 54, 7),
                ),
                title: Text(
                  userEmail,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('update_user');
              },
              child: const Text(
                'تحديث الاسم والايميل ',
                style: TextStyle(
                    // color: Colors.white,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

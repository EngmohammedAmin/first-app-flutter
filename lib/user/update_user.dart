// ignore_for_file: library_private_types_in_public_api, prefer_final_fields, use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UpdateUser extends StatefulWidget {
  const UpdateUser({super.key});

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  User _user = User(); // Initialize with an empty user object
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  void _fetchUser() async {
    // Fetch user data from the backend
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response =
        await http.post(Uri.parse('http://127.0.0.1:8000/api/user'), headers: {
      'Authorization': 'Bearer $token',
    });
    final data = json.decode(response.body);

    // Set the fetched user data to _user
    setState(() {
      _user = User.fromjson(data);
    });
  }

  // void _updateUser() async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  // }

  void _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    // Perform API request to update the user's profile
    final url = Uri.parse('http://127.0.0.1:8000/api/update-user');
    final response = await http.post(url, body: {
      'name': _user.name,
      'email': _user.email,
    }, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      // Profile updated successfully
      print(response.body);
      _showSuccessMessage('Profile updated successfully');
      _fetchUser();

      setState(() {
        _isLoading = false;
      });

      Navigator.pushReplacementNamed(context, 'home_screen');
    } else {
      // Profile update failed
      _showErrorMessage('Profile update failed. Please try again later.');
    }
    // Pass the updated user data to the backend

    // After the update is complete, you can optionally fetch the updated user data again
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    onChanged: (value) {
                      setState(() {
                        _user.name = value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    onChanged: (value) {
                      setState(() {
                        _user.email = value;
                      });
                    },
                  ),
                  // Add more form fields for other user properties

                  const SizedBox(height: 16),

                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text('Update Profile'),
                  ),
                ],
              ),
            ),
    );
  }
}

class User {
  String name = '';
  String email = '';

  // Add more properties as needed
  String? avatarUrl;

  User({
    this.name = '',
    this.email = '',
    this.avatarUrl,
  });

  static User fromjson(data) {
    return User(
      name: data['name'],
      email: data['email'],
    );
  }
}

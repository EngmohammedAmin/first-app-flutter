// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'authentication.dart';
import 'authentication_events.dart';
import 'package:http/http.dart' as http;

class AuthenticationProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  final _email = '';
  final _password = '';

  bool get isLoggedIn => _isLoggedIn;

  Future<void> login({required String email, required String password}) async {
    // Perform login logic...
    // final prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'X-Flutter-App': 'YourCustomHeaderValue',
    };

    final url = Uri.parse('http://127.0.0.1:8000/api/login');
    final response = await http.post(
      url,
      body: {
        'email': _email,
        'password': _password,
      },
      headers: headers,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final token = responseData['access_token'];
      if (token != null) {
        // Store the token in shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        final event = LoginEvent(_email, _password);
        Authentication().processAuthenticationEvent(event);
        Future.delayed(const Duration(seconds: 2), () {
          print('Authentication successful.');
        });
        print(token);

        _isLoggedIn = true;
        notifyListeners();
        // after successful login
      } else {
        print(responseData['data']);
      }
    } else if (response.statusCode == 401) {
      // Handle login failure
      print('Login failed: ${response.statusCode}');
    }
  }

  void logout() {
    // Perform logout logic...
    _isLoggedIn = false;
    notifyListeners();
  }
}

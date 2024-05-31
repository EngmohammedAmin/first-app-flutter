// ignore_for_file: avoid_print, library_private_types_in_public_api, use_build_context_synchronously

// import 'package:first_app/aouthontication/authentication_events.dart';
import 'package:first_app/screens/audio_permission_screen.dart';
import 'package:first_app/screens/home_screen.dart';
// import 'package:first_app/aouthontication/authentication_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../aouthontication/authentication.dart';
import '../aouthontication/authentication_events.dart';

// import '../aouthontication/authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  // var userId;
  // var userName;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://127.0.0.1:8000/api/login');
    final response = await http.post(
      url,
      body: {
        'email': _emailController.text,
        'password': _passwordController.text,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final token = responseData['access_token'];
      final userId = responseData['User_ID'];
      final userName = responseData['user_name'];
      if (token != null) {
        // Store the token in shared preferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        // final event =
        //     LoginEvent(_emailController.text, _passwordController.text);
        // Authentication().processAuthenticationEvent(event);
        Future.delayed(const Duration(seconds: 2), () {
          print('Authentication successful.');
        });
        print(token);
        // Navigator.pushReplacementNamed(
        //   context,
        //   HomeScreen.homeRoute,
        //   arguments: {
        //     'userId': userId,
        //     'userName': userName,
        //   },
        // );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              userId: userId,
              userName: userName,
            ),
          ),
        );

        // after successful login
      } else {
        // setState(() {
        //   _isLoading = false;
        // });
        print(responseData['data']);
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: Colors.amber,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            title: const Text('Error'),
            content: Text(responseData['data']),
            contentTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else if (response.statusCode == 401) {
      // setState(() {
      //   _isLoading = false;
      // });
      // Handle login failure
      print('Login failed: ${response.statusCode}');
      final responseData = json.decode(response.body);

      // Display error message
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Login Failed'),
          content: Text(responseData['error']),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
          title: const Text('Login Screen'),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.audio_file),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AudioPermissionScreen(),
                  ));
            },
          )),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              tileColor: Colors.lightBlue,
              leading: const Icon(Icons.email),
              title: Card(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              style: ListTileStyle.drawer,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              tileColor: Colors.lightBlue,
              leading: const Icon(Icons.password),
              title: Card(
                shadowColor: Colors.black,
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: TextField(
                    maxLength: 8,
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.amber),
                        shadowColor: MaterialStatePropertyAll(Colors.black),
                        elevation: MaterialStatePropertyAll(5),
                        textStyle: MaterialStatePropertyAll(
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      onPressed: _login,
                      // onPressed: () {
                      //   AuthenticationProvider().login(
                      //       email: _emailController.text,
                      //       password: _passwordController.text);
                      //   Navigator.pushNamed(context, 'home_screen');
                      // },
                      child: const Text('Login'),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:first_app/aouthontication/authentication.dart';
import 'package:first_app/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../aouthontication/authentication_events.dart';
import '../fetch_posts.dart';
import '../laravel_flutter_tasks.dart';

class HomeScreen extends StatefulWidget {
  // final String userId;
  static const String homeRoute = 'home_screen';
  const HomeScreen({super.key, required this.userId, required this.userName});
  final int userId;
  final String userName;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _logout() async {
    setState(() {});

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      // Use the token for logout
      final url = Uri.parse('http://127.0.0.1:8000/api/logout');
      final response = await http.post(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        // Logout successful
        setState(() {});

// final storage = FlutterSecureStorage();
//     await storage.delete(key: 'authToken');

        prefs.remove('token');
        const event = LogoutEvent();
        Authentication().processAuthenticationEvent(event);
        Navigator.pushNamed(context, 'login_screen');
        print('response body :${response.body}\n');
        print('response status :${response.statusCode}');
        // Perform any additional actions after successful logout
      } else if (response.statusCode == 401) {
        // Handle error response

        setState(() {});
        print('response body :${response.body}\n');
        print('response status :${response.statusCode}');

        // Handle error response, display error message, etc.
      }
    } else {
      print('no token stored');

      // Handle the case when the token is not available
      Navigator.pushNamed(context, 'login_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    // final Map<String, dynamic>? args =
    //     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    // userId = args?['userId'] ?? 3;
    // userName = args?['userName'] ?? 'Unknown';
    return Scaffold(
      // backgroundColor: Colors.cyan[700],
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.login_outlined),
            tooltip: 'Logout :${widget.userName}',
            onPressed: _logout,
          ),
          const SizedBox(
            width: 20,
          ),
          IconButton(
            icon: const Icon(Icons.mail),
            tooltip: 'User ID :${widget.userId} : ${widget.userName}',
            onPressed: () {},
          ),
        ],
        title: Text(
          '  Laravel Flutter Tasks and Posts',
          style: TextStyle(
            color: _currentIndex == 0 ? Colors.cyan[700] : Colors.white,
            fontFamily: 'Cairo',
            fontSize: 30,
          ),
        ),
        backgroundColor: _currentIndex == 0 ? Colors.white70 : Colors.cyan[700],
        centerTitle: true,
      ),
      // body: const LaravelFlutterTasks(),
      body: _buildScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'fetch posts',
          ),
        ],
      ),
    );
  }

  Widget _buildScreen() {
    switch (_currentIndex) {
      case 0:
        return const Center(
          child: MainPage(),
        );

      case 1:
        return const LaravelFlutterTasks();

      // case 2:
      //   return const LaravelFlutterTasks();
      case 2:
        return const FetchPosts();
      default:
        throw Exception('Invalid index: $_currentIndex');
    }
  }
}

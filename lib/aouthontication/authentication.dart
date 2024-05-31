// ignore_for_file: avoid_print

import 'package:shared_preferences/shared_preferences.dart';

import 'authentication_events.dart';

class Authentication {
  bool isLoggedIn = false;

  Future<void> login(String username, String password) async {
    // Perform login logic here...
    isLoggedIn = true;
    print('User $username logged in successfully.');

    // Perform authentication logic here...
    print('Performing authentication logic...');

    // Simulate authentication delay
    Future.delayed(const Duration(seconds: 2), () {
      print('Authentication successful.');
    });

    // Perform additional actions after successful login
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', 'some_token');

    // Dispatch the LoginEvent
    final event = LoginEvent(username, password);
    processAuthenticationEvent(event);
  }

  Future<void> logout() async {
    // Perform logout logic here...
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    print('User logged out successfully.');

    // Dispatch the LogoutEvent
    const event = LogoutEvent();
    processAuthenticationEvent(event);
  }

  void processAuthenticationEvent(AuthenticationEvent event) {
    if (event is LoginEvent) {
      // Handle login event
      print('Processing login event: ${event.username}');
      isLoggedIn = true;
    } else if (event is LogoutEvent) {
      // Handle logout event
      print('Processing logout event');
      isLoggedIn = false;
    }
  }
}

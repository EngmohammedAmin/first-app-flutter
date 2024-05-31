// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:first_app/profile.dart';
import 'package:first_app/screens/login_screen.dart';
import 'package:first_app/screens/sound_lavel_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// import 'aouthontication/authentication_provider.dart';
import 'laravel_flutter.dart';
import 'posts/create_post_page.dart';
import 'screens/audio_permission_screen.dart';
import 'user/update_user.dart';
// import 'package:http/http.dart' as http;

void main() {
  //  WidgetsFlutterBinding.ensureInitialized();
  // await ui.platformViewRegistry.registerViewFactory(
  //   'hello-world-html',
  //   (int viewId) => html.DivElement()..text = 'Hello, World!',
  // );
  // ChangeNotifierProvider(
  //   create: (_) => AuthenticationProvider(),
  //   child: const MyWidget(),
  // );
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(
    const MyWidget(),
  );
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LaravelFlutter(),
      home: const LoginScreen(),
      // home: new Scaffold(
      //   body: SafeArea(
      //     child: new SoundLavelPage(),
      //   ),
      // ),

      routes: {
        'profile': (context) => const Profile(),
        'create_posts': (context) => const CreatePostPage(),
        'laravel_flutter': (context) => const LaravelFlutter(),
        'update_user': (context) => const UpdateUser(),
        // HomeScreen.homeRoute: (context) => const HomeScreen(
        //       userId: 0,
        //       userName: '',
        //     ),
        'login_screen': (context) => const LoginScreen(),
        'audio_permission_screen': (context) => const AudioPermissionScreen(),
      },
    );
  }
}

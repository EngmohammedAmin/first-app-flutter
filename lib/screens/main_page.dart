import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Main Page'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              const Text('Main Page'),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('update_user');
                },
                child: const Text('update user Page',
                    style: TextStyle(color: Colors.white)),
              ),
              const Text('or'),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('profile');
                },
                child: const Text('go to profile page',
                    style: TextStyle(color: Colors.white)),
              ),
               const Text('or'),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('create_posts');
                },
                child: const Text('go to create post page',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ));
  }
}

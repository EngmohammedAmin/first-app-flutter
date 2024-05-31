// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final TextEditingController _noteController = TextEditingController();

  Future<void> _createPost() async {
    final String title = _titleController.text;
    final String age = _contentController.text;
    final String note = _noteController.text;

    final Map<String, dynamic> postData = {
      'name': title,
      'age': age,
      'note': note
    };
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final Uri uri = Uri.parse('http://localhost:8000/api/create-posts');
    final response = await http.post(uri, body: postData, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String postName = responseData['name'];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: Text('Post created with Name is: $postName'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _titleController.text = '';
                  _contentController.text = '';
                  _noteController.text = '';
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to create post.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
        title: const Text(
          'Create Post',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Card(
              shadowColor: Colors.black,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              shadowColor: Colors.black,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(labelText: 'Age'),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Card(
              shadowColor: Colors.black,
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: TextField(
                  controller: _noteController,
                  decoration: const InputDecoration(labelText: 'Note'),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _createPost,
              child: const Text('Create Post'),
            ),
          ],
        ),
      ),
    );
  }
}

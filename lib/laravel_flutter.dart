// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LaravelFlutter extends StatefulWidget {
  const LaravelFlutter({super.key});

  @override
  _LaravelFlutterState createState() => _LaravelFlutterState();
}

class _LaravelFlutterState extends State<LaravelFlutter> {
  List<dynamic> posts = [];
  bool isLoading = false;
  int currentPage = 1;
  int totalPages = 1;
  int pageSize = 10; // Number of posts to display per page

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.get(
          Uri.parse(
            'http://127.0.0.1:8000/api/posts?page=$currentPage',
          ),
          headers: {
            'Authorization': 'Bearer $token',
          });
      // print(response.body);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null && jsonData['data'] != null) {
          setState(() {
            posts = jsonData['data'];
            totalPages = jsonData['last_page'];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            posts = [];
          });
          print('No posts found in the response.');
        }
      } else {
        setState(() {
          isLoading = false;
          posts = [];
        });
        print('Failed to fetch posts. Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        posts = [];
      });
      print('An error occurred while fetching posts: $e');
    }
  }

  void nextPage() {
    if (currentPage < totalPages) {
      currentPage++;
      fetchPosts();
    }
  }

  void previousPage() {
    if (currentPage > 1) {
      currentPage--;
      fetchPosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.blueGrey,
                              Colors.white,
                              Colors.blueGrey,
                              // Colors.white,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.8),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.all(10),
                        child: ListTile(
                          onTap: () {
                            // Handle post tap
                          },
                          hoverColor: Colors.blue[50],
                          title: Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: 200,
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              post['name'] ?? '',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                          subtitle: Text(
                            post['created_at'] ?? '',
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                              shadows: const <Shadow>[
                                Shadow(
                                  offset: Offset(1.0, -1.0),
                                  blurRadius: 1.0,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: previousPage,
                    ),
                    Text('Page $currentPage of $totalPages'),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: nextPage,
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

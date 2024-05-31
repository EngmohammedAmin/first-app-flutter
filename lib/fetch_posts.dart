// ignore_for_file: avoid_print, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FetchPosts extends StatefulWidget {
  const FetchPosts({super.key});

  @override
  _FetchPostsState createState() => _FetchPostsState();
}

class _FetchPostsState extends State<FetchPosts> {
  List<dynamic> posts = [];
  bool isLoading = false;
  int currentPage = 1;
  int totalPages = 1;
  int pageSize = 10; // Number of posts to display per page

  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    fetchPosts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        fetchMorePosts();
      }
    });
  }

  Future<void> fetchPosts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final url =
          Uri.parse('http://127.0.0.1:8000/api/posts?page=$currentPage');
      final response = await http.get(url, headers: {
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

  Future<void> fetchMorePosts() async {
    if (!_isFetchingMore && currentPage < totalPages) {
      setState(() {
        _isFetchingMore = true;
      });

      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        final response = await http.get(
            Uri.parse(
              'http://127.0.0.1:8000/api/posts?page=${currentPage + 1}',
            ),
            headers: {
              'Authorization': 'Bearer $token',
            });
        // print(response.body);
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          if (jsonData != null && jsonData['data'] != null) {
            setState(() {
              posts.addAll(jsonData['data']);
              currentPage++;
              _isFetchingMore = false;
            });
          } else {
            setState(() {
              _isFetchingMore = false;
            });
            print('No more posts found in the response.');
          }
        } else {
          setState(() {
            _isFetchingMore = false;
          });
          print('Failed to fetch more posts. Error: ${response.statusCode}');
        }
      } catch (e) {
        setState(() {
          _isFetchingMore = false;
        });
        print('An error occurred while fetching more posts: $e');
      }
    }
  }

  Future<void> refreshPosts() async {
    currentPage = 1;
    await fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : RefreshIndicator(
                onRefresh: refreshPosts,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      posts.length + 1, // Add 1 for the loading indicator
                  itemBuilder: (context, index) {
                    if (index == posts.length) {
                      if (currentPage < totalPages) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Container(); // No more posts to load
                      }
                    }

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

                      // Add your post item widget here
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
                      // Post item widget
                    );
                  },
                ),
              ),
      ),
    );
  }
}

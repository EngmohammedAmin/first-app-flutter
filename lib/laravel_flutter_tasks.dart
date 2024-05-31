// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LaravelFlutterTasks extends StatefulWidget {
  const LaravelFlutterTasks({super.key});

  @override
  State<LaravelFlutterTasks> createState() => _LaravelFlutterTasksState();
}

class _LaravelFlutterTasksState extends State<LaravelFlutterTasks> {
  List<dynamic> tasks = [];
  bool isLoading = false;

  int currentPage = 1;
  int totalPages = 1;
  int pageSize = 10; // Number of posts to display per page

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    setState(() {
      isLoading = true;
    });

    try {

       final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
      final response = await http
          .get(Uri.parse('http://127.0.0.1:8000/api/tasks?page=$currentPage',), headers: {
        'Authorization': 'Bearer $token',
          });
      // print(response.body);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null && jsonData['data'] != null) {
          setState(() {
            tasks = jsonData['data'];
            totalPages = jsonData['last_page'];
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
            tasks = [];
          });
          print('No tasks found in the response.');
        }
      } else {
        setState(() {
          isLoading = false;
          tasks = [];
        });
        print('Failed to fetch tasks. Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        tasks = [];
      });
      print('An error occurred while fetching tasks: $e');
    }
  }

  void nextPage() {
    if (currentPage < totalPages) {
      currentPage++;
      fetchTasks();
    }
  }

  void previousPage() {
    if (currentPage > 1) {
      currentPage--;
      fetchTasks();
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
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
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
                              task['title'] ?? '',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                          ),
                          subtitle: Text(
                            task['created_at'] ?? '',
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

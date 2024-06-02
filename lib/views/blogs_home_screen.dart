import 'dart:io';
import 'package:demo_app/controller/theme_controller.dart';
import 'package:demo_app/database/database.dart';
import 'package:demo_app/model/blogs_data_model.dart';
import 'package:demo_app/routes/routes.dart';
import 'package:demo_app/views/blogs_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class BlogsHomeScreen extends StatefulWidget {
  const BlogsHomeScreen({super.key});

  @override
  State createState() => _BlogsHomeScreenState();
}

class _BlogsHomeScreenState extends State<BlogsHomeScreen> {
  late DatabaseHelper databaseHelper;
  List<BlogsModel> blogPosts = [];
  final ThemeController themeController = Get.find();

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    _loadBlogs();
  }

  Future<void> _loadBlogs() async {
    final blog = await databaseHelper.getblogs();
    if (mounted) {
      setState(() {
        blogPosts = blog;
      });
    }
  }

  void _showDeleteConfirmationDialog(BlogsModel blog) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this blog post?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteBlogs(context, blog);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteBlogs(BuildContext context, BlogsModel blog) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteBlogs(blog.id!);
    Fluttertoast.showToast(msg: 'Blog deleted successfully', gravity: ToastGravity.BOTTOM);
    _loadBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: const Text('Home'),
        actions: [
          Obx(() {
            return IconButton(
              icon: Icon(themeController.themeMode.value == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
              onPressed: themeController.toggleTheme,
            );
          }),
        ],
      ),
      body: blogPosts.isNotEmpty
          ? ListView.builder(
              itemCount: blogPosts.length,
              itemBuilder: (context, index) {
                final blogPost = blogPosts[index];
                return Card(
                  margin: const EdgeInsets.all(10.0),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'edit') {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BlogsUpdateScreen(
                                    blogPost: blogPosts[index],
                                  ),
                                ),
                              );
                            } else if (value == 'delete') {
                              _showDeleteConfirmationDialog(blogPost);
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete),
                                    SizedBox(width: 8),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ];
                          },
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text(
                              blogPost.title,
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              blogPost.body,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(blogPost.imageUrl),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(child: Text("No Data Found")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(RoutesClass.getAddBlogPostScreenRoute());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

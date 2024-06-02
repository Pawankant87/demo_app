import 'package:demo_app/database/database.dart';
import 'package:demo_app/model/blogs_data_model.dart';
import 'package:demo_app/routes/routes.dart';
import 'package:demo_app/views/blog_form.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class BlogsUpdateScreen extends StatelessWidget {
  final BlogsModel blogPost;

  const BlogsUpdateScreen({super.key, required this.blogPost});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Update blogs'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlogsForm(
          blogs: blogPost,
          onSave: (updatedBlogs) async {
            try {
              final dbHelper = DatabaseHelper();
              await dbHelper.updateBlogs(updatedBlogs);
              Fluttertoast.showToast(msg: 'Blogs updated successfully', gravity: ToastGravity.BOTTOM);
              Get.offAllNamed(RoutesClass.getBlogsHomeScreenRoute());
            } catch (e) {
              Fluttertoast.showToast(msg: 'Error updating blogs: $e', gravity: ToastGravity.BOTTOM);
            }
          },
        ),
      ),
    );
  }
}

import 'dart:io';
import 'package:demo_app/database/database.dart';
import 'package:demo_app/model/blogs_data_model.dart';
import 'package:demo_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddBlogPostScreen extends StatefulWidget {
  const AddBlogPostScreen({super.key});

  @override
  State createState() => _AddBlogPostScreenState();
}

class _AddBlogPostScreenState extends State<AddBlogPostScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  late DatabaseHelper databaseHelper;
  File? imageFile;
  TextEditingController titleController = TextEditingController();
  TextEditingController bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  bool isImage = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
          isImage = true;
          Navigator.of(context).pop();
        });
      }
    } catch (e) {
      setState(() {
        Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Add Blog Post'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text('Body'),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1.0,
                    ),
                  ),
                  child: TextFormField(
                    controller: bodyController,
                    decoration: const InputDecoration(
                      hintText: 'Enter your blog post content...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                      border: InputBorder.none,
                    ),
                    maxLines: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the body text';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Get.defaultDialog(
                          title: 'Pick Image',
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Icon(Icons.camera),
                                TextButton(
                                  onPressed: () async {
                                    _pickImage(ImageSource.camera);
                                  },
                                  child: const Text("Camera"),
                                ),
                                SizedBox(
                                  height: 50,
                                  child: VerticalDivider(
                                    thickness: 2,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                const Icon(Icons.photo_library),
                                TextButton(
                                  onPressed: () async {
                                    _pickImage(ImageSource.gallery);
                                  },
                                  child: const Text("Gallery"),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: isImage == false
                          ? TextButton(
                              onPressed: () {
                                Get.defaultDialog(
                                  title: 'Pick Image',
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Icon(Icons.camera),
                                        TextButton(
                                          onPressed: () async {
                                            _pickImage(ImageSource.camera);
                                          },
                                          child: const Text("Camera"),
                                        ),
                                        SizedBox(
                                          height: 50,
                                          child: VerticalDivider(
                                            thickness: 2,
                                            color: Theme.of(context).colorScheme.secondary,
                                          ),
                                        ),
                                        const Icon(Icons.photo_library),
                                        TextButton(
                                          onPressed: () async {
                                            _pickImage(ImageSource.gallery);
                                          },
                                          child: const Text("Gallery"),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Select Image'),
                            )
                          : SizedBox(
                              height: 200,
                              width: 200,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Image.file(
                                  imageFile!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (formkey.currentState!.validate()) {
                        if (imageFile != null) {
                          await databaseHelper.insertBlogs(BlogsModel(
                            title: titleController.text,
                            body: bodyController.text,
                            imageUrl: imageFile!.path,
                          ));
                          Fluttertoast.showToast(msg: 'blogs added successfully', gravity: ToastGravity.BOTTOM);
                          titleController.clear();
                          bodyController.clear();
                          Get.offAllNamed(RoutesClass.getBlogsHomeScreenRoute());
                        } else {
                          Fluttertoast.showToast(
                            msg: "Plase select Image",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                          );
                        }
                      }
                    },
                    child: const Text('Add Blog Post'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

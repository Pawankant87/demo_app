import 'dart:io';
import 'package:demo_app/model/blogs_data_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class BlogsForm extends StatefulWidget {
  final BlogsModel? blogs;
  final void Function(BlogsModel) onSave;
  const BlogsForm({super.key, this.blogs, required this.onSave});

  @override
  State createState() => _BlogsFormState();
}

class _BlogsFormState extends State<BlogsForm> {
  final _formKey = GlobalKey<FormState>();
  late String title, body, imageUrl;
  double? latitude, longitude;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.blogs != null) {
      title = widget.blogs!.title;
      body = widget.blogs!.body;
      imageUrl = widget.blogs!.imageUrl;
      imageFile = imageUrl.isNotEmpty ? File(imageUrl) : null;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error picking image: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            initialValue: title,
            decoration: const InputDecoration(labelText: 'Title'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a title';
              }
              return null;
            },
            onSaved: (value) => title = value!,
          ),
          const SizedBox(height: 20),
          const Text('Body'),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                color: Colors.grey, // Adjust the color as per your design
                width: 1.0,
              ),
            ),
            child: TextFormField(
              initialValue: body,
              decoration: const InputDecoration(
                hintText: 'Enter your blog post content...',
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                border: InputBorder.none, // Remove default border
              ),
              maxLines: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the body text';
                }
                return null;
              },
              onSaved: (value) => body = value!,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Stack(
                children: [
                  if (imageFile != null)
                    Image.file(
                      imageFile!,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      height: 200,
                      width: 200,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: IconButton(
                      iconSize: 60,
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
                                    Navigator.of(context).pop();
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
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Gallery"),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                if (imageFile != null) {
                  widget.onSave(
                    BlogsModel(
                      id: widget.blogs?.id,
                      title: title,
                      body: body,
                      imageUrl: imageFile!.path,
                    ),
                  );
                } else {
                  Fluttertoast.showToast(
                    msg: 'Please select an image',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                  );
                }
              }
            },
            child: const Text('Update Blog Post'),
          ),
        ],
      ),
    );
  }
}

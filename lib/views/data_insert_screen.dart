import 'dart:io';
import 'package:demo_app/database/database.dart';
import 'package:demo_app/model/customer_model.dart';
import 'package:demo_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddCustomerPage extends StatefulWidget {
  const AddCustomerPage({super.key});

  @override
  State createState() => _AddCustomerPageState();
}

class _AddCustomerPageState extends State<AddCustomerPage> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  late DatabaseHelper databaseHelper;
  String currentAddress = '';
  double latitude = 0.0;
  double longitude = 0.0;
  File? imageFile;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    mobileNoController.dispose();
    emailController.dispose();
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
        title: const Text('Add Customer'),
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
                  controller: fullNameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Full Name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: mobileNoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Mobile No'),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a number';
                    }
                    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Please enter a valid 10-digit number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email ID'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter an email address';
                    }
                    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                    if (!emailRegex.hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                // Other fields
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please wait loading address';
                    }
                    return null;
                  },
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
                            ));
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
                        try {
                          if (imageFile != null) {
                            await databaseHelper.insertCustomer(Customer(
                              name: fullNameController.text,
                              mobile: mobileNoController.text,
                              email: emailController.text,
                              address: addressController.text,
                              imageUrl: imageFile!.path.toString(),
                            ));
                            Fluttertoast.showToast(msg: 'Customer added successfully', gravity: ToastGravity.BOTTOM);
                            fullNameController.clear();
                            mobileNoController.clear();
                            emailController.clear();
                            addressController.clear();
                            Get.offAllNamed(RoutesClass.getCustomerListPageRoute());
                          } else {
                            Fluttertoast.showToast(
                              msg: "Plase select Image",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                            );
                          }
                        } catch (e) {
                          Fluttertoast.showToast(msg: 'Failed to add customer: $e', gravity: ToastGravity.BOTTOM);
                        }
                      }
                    },
                    child: const Text('Add Customer'),
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

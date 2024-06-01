import 'dart:io';
import 'package:demo_app/database/database.dart';
import 'package:demo_app/model/customer_model.dart';
import 'package:demo_app/views/customers_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UpdateCustomerPage extends StatelessWidget {
  final Customer customer;

  const UpdateCustomerPage({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Update Customer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomerForm(
          customer: customer,
          onSave: (updatedCustomer) async {
            final dbHelper = DatabaseHelper();
            await dbHelper.updateCustomer(updatedCustomer);
            Fluttertoast.showToast(msg: 'Customer updated successfully', gravity: ToastGravity.BOTTOM);
            Get.offAll(() => CustomerDetailsPage(customer: updatedCustomer));
          },
        ),
      ),
    );
  }
}

class CustomerForm extends StatefulWidget {
  final Customer? customer;
  final void Function(Customer) onSave;

  const CustomerForm({super.key, this.customer, required this.onSave});

  @override
  State createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  late String name, mobile, email, address, imageUrl;
  double? latitude, longitude;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.customer != null) {
      name = widget.customer!.name;
      mobile = widget.customer!.mobile;
      email = widget.customer!.email;
      address = widget.customer!.address;
      imageUrl = widget.customer!.imageUrl;
      imageFile = imageUrl.isNotEmpty ? File(imageUrl) : null;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
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
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            initialValue: name,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Full Name';
              }
              return null;
            },
            onSaved: (value) => name = value!,
          ),
          TextFormField(
            initialValue: email,
            decoration: const InputDecoration(labelText: 'Email'),
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
            onSaved: (value) => mobile = value!,
          ),
          TextFormField(
            initialValue: mobile,
            decoration: const InputDecoration(labelText: 'Mobile'),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a number';
              }
              if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                return 'Please enter a valid 10-digit number';
              }
              return null;
            },
            onSaved: (value) => email = value!,
          ),
          TextFormField(
            initialValue: address,
            decoration: const InputDecoration(labelText: 'Address'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please wait loading address';
              }
              return null;
            },
            onSaved: (value) => address = value!,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Stack(
                children: [
                  imageFile != null
                      ? Image.file(
                          imageFile!,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        )
                      : Container(
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    const Icon(Icons.camera),
                                    TextButton(
                                      onPressed: () async {
                                        await _pickImage(ImageSource.camera);
                                      },
                                      child: const Text("Camera"),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(Icons.photo_library),
                                    TextButton(
                                      onPressed: () async {
                                        await _pickImage(ImageSource.gallery);
                                      },
                                      child: const Text("Gallery"),
                                    ),
                                  ],
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
                    Customer(
                      id: widget.customer?.id,
                      name: name,
                      mobile: mobile,
                      email: email,
                      address: address,
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
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

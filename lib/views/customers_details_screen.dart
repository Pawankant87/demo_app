import 'dart:io';
import 'package:demo_app/database/database.dart';
import 'package:demo_app/model/customer_model.dart';
import 'package:demo_app/routes/routes.dart';
import 'package:demo_app/views/customers_update_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class CustomerDetailsPage extends StatefulWidget {
  final Customer customer;

  const CustomerDetailsPage({super.key, required this.customer});

  @override
  State<CustomerDetailsPage> createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.customer.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed(RoutesClass.getCustomerListPageRoute());
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _navigateToUpdatePage(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _deleteCustomer(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${widget.customer.name}'),
            Text('Mobile: ${widget.customer.mobile}'),
            Text('Email: ${widget.customer.email}'),
            Text('Address: ${widget.customer.address}'),
            const SizedBox(height: 16.0),
            SizedBox(
              height: 200,
              width: 200,
              child: Image.file(
                File(widget.customer.imageUrl),
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  void _navigateToUpdatePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateCustomerPage(customer: widget.customer),
      ),
    );
  }

  void _deleteCustomer(BuildContext context) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteCustomer(widget.customer.id!);
    Fluttertoast.showToast(msg: 'Customer delete successfully', gravity: ToastGravity.BOTTOM);
    Get.offAllNamed(RoutesClass.getCustomerListPageRoute());
  }
}

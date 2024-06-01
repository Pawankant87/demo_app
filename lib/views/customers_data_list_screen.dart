import 'dart:io';

import 'package:demo_app/controller/theme_controller.dart';
import 'package:demo_app/database/database.dart';
import 'package:demo_app/model/customer_model.dart';
import 'package:demo_app/routes/routes.dart';
import 'package:demo_app/views/customers_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerListPage extends StatefulWidget {
  const CustomerListPage({super.key});

  @override
  State createState() => _CustomerListPageState();
}

class _CustomerListPageState extends State<CustomerListPage> {
  late DatabaseHelper databaseHelper;
  List<Customer> customers = [];
  final ThemeController themeController = Get.find();

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    final customer = await DatabaseHelper().getCustomers();
    if (mounted) {
      setState(() {
        customers = customer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer List'),
        actions: [
          Obx(() {
            return IconButton(
              icon: Icon(themeController.themeMode.value == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
              onPressed: themeController.toggleTheme,
            );
          }),
          TextButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('password');
              prefs.remove('email');
              Get.offAllNamed(RoutesClass.getLoginScreenRoute());
              Fluttertoast.showToast(msg: 'Logout successfully', gravity: ToastGravity.BOTTOM);
            },
            child: const Text('Logout'),
          ),
        ],
      ),
      body: customers.isNotEmpty
          ? ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return Card(
                  child: ListTile(
                    leading: Image.file(
                      File(customer.imageUrl),
                    ),
                    title: Text(customer.name),
                    subtitle: Text(customer.mobile),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerDetailsPage(customer: customer),
                        ),
                      );
                    },
                  ),
                );
              },
            )
          : const Center(child: Text("No Data Found")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(RoutesClass.getAddCustomerPageRoute());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

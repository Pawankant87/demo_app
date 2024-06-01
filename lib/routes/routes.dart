import 'package:demo_app/views/customers_data_list_screen.dart';
import 'package:demo_app/views/data_insert_screen.dart';
import 'package:demo_app/views/login_screen.dart';
import 'package:demo_app/views/splash_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class RoutesClass {
  static String splashScreen = '/';
  static String customerListPage = '/customerListPage';
  static String loginScreen = '/loginScreen';
  static String addCustomerPage = '/addCustomerPage';

  static String getSplashScreen() => splashScreen;
  static String getCustomerListPageRoute() => customerListPage;
  static String getLoginScreenRoute() => loginScreen;
  static String getAddCustomerPageRoute() => addCustomerPage;

  static List<GetPage> routes = [
    GetPage(
      name: splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: customerListPage,
      page: () => const CustomerListPage(),
    ),
    GetPage(
      name: loginScreen,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: addCustomerPage,
      page: () => const AddCustomerPage(),
    ),
  ];
}

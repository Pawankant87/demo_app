import 'package:demo_app/views/blogs_home_screen.dart';
import 'package:demo_app/views/blogs_posts_screen.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class RoutesClass {
  static String blogsHomeScreen = '/';
  static String addBlogPostScreen = '/addBlogPostScreen';

  static String getBlogsHomeScreenRoute() => blogsHomeScreen;
  static String getAddBlogPostScreenRoute() => addBlogPostScreen;

  static List<GetPage> routes = [
    GetPage(
      name: blogsHomeScreen,
      page: () => const BlogsHomeScreen(),
    ),
    GetPage(
      name: addBlogPostScreen,
      page: () => const AddBlogPostScreen(),
    ),
  ];
}

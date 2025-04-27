import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/login_screen.dart';
import 'screens/forget_pasword_page.dart';
import 'screens/signup_screen.dart';
import 'screens/options_page.dart';
import 'screens/manage_products_page.dart';
import 'screens/add_product_page.dart';
import 'screens/delete_product_page.dart';
import 'screens/view_product_page.dart';
import 'screens/update_product_page.dart';
import 'screens/all_products_page.dart'; // newly added
import 'screens/view_orders_page.dart';
import 'screens/manage_inventory_page.dart';
import 'screens/manage_categories_page.dart';
import 'screens/batch_update_products_page.dart';
import 'screens/track_inventory_history_page.dart';
import 'screens/delete_archive_products_page.dart';
import 'screens/create_promotions_page.dart';
import 'screens/discount_page.dart';
import 'screens/free_shipping_page.dart';
import 'screens/promo_codes_pages.dart';
import 'screens/validity_page.dart';
import 'screens/customer_review_page.dart';
import 'screens/generate_reports_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/forgotPassword': (context) => const ForgotPasswordPage(),
        '/signup': (context) => const SignupPage(),
        '/options': (context) => const OptionsPage(),
        '/manageProducts': (context) => const ManageProductsPage(),
        '/manageInventory': (context) => const ManageInventoryPage(),
        '/addProduct': (context) => const AddProductPage(),
        '/deleteProduct': (context) => const DeleteProductPage(),
        '/viewProduct': (context) => const ViewProductPage(),
        '/viewOrders': (context) => const ViewOrdersPage(),
        '/updateProduct': (context) => const UpdateProductPage(),
        '/allProducts': (context) => const AllProductsPage(), // new route
        '/manage_categories': (context) => const ManageCategoriesPage(),
        '/batch_update': (context) =>const  BatchUpdatePage(),
        '/track_inventory': (context) => const TrackInventoryStreamPage(),
        '/delete_archived': (context) => const DeleteArchivedProductsPage(),
       '/createPromotions': (context) =>const  CreatePromotionsPage(), 
        '/discount': (context) =>const  DiscountPage(),
        '/freeShipping': (context) => const FreeShippingPage(),
        '/validityPeriod': (context) => const ValidityPeriodPage(),
        '/promoCodes': (context) => const PromoCodesPage(),
        '/generatereports': (context) => const GenerateReportsPage(),  // Add this line
    '/customerreviews': (context) => const CustomerReviewsPage(),  // Add this line
      },
    );
  }
}


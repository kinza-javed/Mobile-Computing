import 'package:flutter/material.dart';

class OptionsPage extends StatelessWidget {
  const OptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Options Management'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/logo.png'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildOptionButton(context, 'Manage Products', '/manageProducts'),
                  _buildOptionButton(context, 'View Orders', '/viewOrders'),
                  _buildOptionButton(context, 'Manage Inventory', '/manageInventory'),
                  _buildOptionButton(context, 'Create Promotions', '/createPromotions'), // Fixed the casing here
                  _buildOptionButton(context, 'Generate Reports', '/generatereports'),
                  _buildOptionButton(context, 'View Customer Reviews', '/customerreviews'),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to Change Password screen if needed
              },
              icon: const Icon(Icons.lock_reset),
              label: const Text('Change Password'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, String title, String routeName) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, routeName),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        textStyle: const TextStyle(fontSize: 14),
      ),
      child: Text(title, textAlign: TextAlign.center),
    );
  }
}
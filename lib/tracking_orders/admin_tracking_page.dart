import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/services/tracking_service.dart';


class AdminTrackingPage extends StatefulWidget {
  const AdminTrackingPage({Key? key}) : super(key: key);

  @override
  _AdminTrackingPageState createState() => _AdminTrackingPageState();
}

class _AdminTrackingPageState extends State<AdminTrackingPage> {
  final List<Map<String, dynamic>> _orders = [
    {
      'id': '123456',
      'status': 'In Transit',
      'customer': 'John Doe',
      'items': [
        {'name': 'Red Roses Bouquet', 'quantity': 1},
        {'name': 'Chocolate Box', 'quantity': 1},
      ],
      'orderDate': DateTime.now().subtract(const Duration(days: 2)),
      'estimatedDelivery': DateTime.now().add(const Duration(days: 1)),
      'currentLocation': 'Local Distribution Center',
      'trackingEvents': [
        {
          'status': 'Order Placed',
          'location': 'Online',
          'timestamp': DateTime.now().subtract(const Duration(days: 2)),
          'description': 'Order received and is being processed.'
        },
        {
          'status': 'Order Processed',
          'location': 'Warehouse',
          'timestamp': DateTime.now().subtract(const Duration(days: 1, hours: 12)),
          'description': 'Order has been prepared and packaged.'
        },
        {
          'status': 'In Transit',
          'location': 'Local Distribution Center',
          'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
          'description': 'Order is on its way to the customer.'
        },
      ],
    },
    {
      'id': '789012',
      'status': 'Processing',
      'customer': 'Jane Smith',
      'items': [
        {'name': 'Birthday Gift Basket', 'quantity': 1},
      ],
      'orderDate': DateTime.now().subtract(const Duration(hours: 12)),
      'estimatedDelivery': DateTime.now().add(const Duration(days: 3)),
      'currentLocation': 'Warehouse',
      'trackingEvents': [
        {
          'status': 'Order Placed',
          'location': 'Online',
          'timestamp': DateTime.now().subtract(const Duration(hours: 12)),
          'description': 'Order received and is being processed.'
        },
      ],
    },
    {
      'id': '345678',
      'status': 'Delivered',
      'customer': 'Michael Johnson',
      'items': [
        {'name': 'Anniversary Flower Arrangement', 'quantity': 1},
        {'name': 'Greeting Card', 'quantity': 1},
      ],
      'orderDate': DateTime.now().subtract(const Duration(days: 5)),
      'estimatedDelivery': DateTime.now().subtract(const Duration(days: 1)),
      'currentLocation': 'Customer Address',
      'trackingEvents': [
        {
          'status': 'Order Placed',
          'location': 'Online',
          'timestamp': DateTime.now().subtract(const Duration(days: 5)),
          'description': 'Order received and is being processed.'
        },
        {
          'status': 'Order Processed',
          'location': 'Warehouse',
          'timestamp': DateTime.now().subtract(const Duration(days: 4)),
          'description': 'Order has been prepared and packaged.'
        },
        {
          'status': 'In Transit',
          'location': 'Local Distribution Center',
          'timestamp': DateTime.now().subtract(const Duration(days: 3)),
          'description': 'Order is on its way to the customer.'
        },
        {
          'status': 'Out for Delivery',
          'location': 'Local Courier',
          'timestamp': DateTime.now().subtract(const Duration(days: 2)),
          'description': 'Order is out for delivery.'
        },
        {
          'status': 'Delivered',
          'location': 'Customer Address',
          'timestamp': DateTime.now().subtract(const Duration(days: 1)),
          'description': 'Order has been delivered successfully.'
        },
      ],
    },
  ];

  String _searchQuery = '';
  List<Map<String, dynamic>> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    _filteredOrders = [..._orders];
  }

  void _filterOrders(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredOrders = [..._orders];
      } else {
        _filteredOrders = _orders.where((order) {
          return order['id'].toString().contains(query) ||
              order['customer'].toString().toLowerCase().contains(query.toLowerCase()) ||
              order['status'].toString().toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _filteredOrders = [..._orders];
                _searchQuery = '';
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterOrders,
              decoration: InputDecoration(
                labelText: 'Search orders by ID, customer, or status',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _filterOrders('');
                          });
                        },
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: _filteredOrders.isEmpty
                ? const Center(child: Text('No orders found'))
                : ListView.builder(
                    itemCount: _filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = _filteredOrders[index];
                      return _buildOrderCard(order);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddUpdateTrackingEvent(null);
        },
        child: const Icon(Icons.add),
        tooltip: 'Add New Order',
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final DateFormat dateFormat = DateFormat('MMM dd, yyyy');
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: _getStatusIcon(order['status']),
        title: Text('Order #${order['id']} - ${order['customer']}'),
        subtitle: Text('Status: ${order['status']} | ${dateFormat.format(order['orderDate'])}'),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Customer', order['customer']),
                _buildInfoRow('Order Date', dateFormat.format(order['orderDate'])),
                _buildInfoRow('Estimated Delivery', dateFormat.format(order['estimatedDelivery'])),
                _buildInfoRow('Current Location', order['currentLocation']),
                const Divider(),
                const Text(
                  'Items:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...order['items'].map<Widget>((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text('${item['quantity']}x ${item['name']}'),
                  );
                }).toList(),
                const Divider(),
                const Text(
                  'Tracking Events:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildTrackingEvents(order),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Event'),
                      onPressed: () {
                        _showAddUpdateTrackingEvent(order);
                      },
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Update Status'),
                      onPressed: () {
                        _showUpdateStatusDialog(order);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildTrackingEvents(Map<String, dynamic> order) {
    final DateFormat dateFormat = DateFormat('MMM dd, hh:mm a');
    final events = order['trackingEvents'] as List;
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[events.length - 1 - index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _getStatusColor(event['status']),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            ),
          ),
          title: Text(event['status']),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${event['location']} - ${dateFormat.format(event['timestamp'])}'),
              Text(event['description']),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _showDeleteEventDialog(order, event);
            },
          ),
        );
      },
    );
  }

  Icon _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'processing':
        return const Icon(Icons.hourglass_top, color: Colors.blue);
      case 'shipped':
      case 'in transit':
        return const Icon(Icons.local_shipping, color: Colors.orange);
      case 'out for delivery':
        return const Icon(Icons.delivery_dining, color: Colors.purple);
      case 'delivered':
        return const Icon(Icons.check_circle, color: Colors.green);
      case 'cancelled':
        return const Icon(Icons.cancel, color: Colors.red);
      default:
        return const Icon(Icons.help, color: Colors.grey);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'order placed':
        return Colors.blue;
      case 'order processed':
        return Colors.indigo;
      case 'shipped':
      case 'in transit':
        return Colors.orange;
      case 'out for delivery':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showAddUpdateTrackingEvent(Map<String, dynamic>? order) {
    final isNewOrder = order == null;
    
    final orderIdController = TextEditingController(text: isNewOrder ? '' : order['id']);
    final customerController = TextEditingController(text: isNewOrder ? '' : order['customer']);
    
    final statusController = TextEditingController();
    final locationController = TextEditingController();
    final descriptionController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isNewOrder ? 'Add New Order' : 'Add Tracking Event'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isNewOrder) ...[
                TextField(
                  controller: orderIdController,
                  decoration: const InputDecoration(labelText: 'Order ID'),
                ),
                TextField(
                  controller: customerController,
                  decoration: const InputDecoration(labelText: 'Customer Name'),
                ),
                const SizedBox(height: 16),
              ],
              TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              if (isNewOrder) {
                // Create new order
                if (orderIdController.text.isNotEmpty && customerController.text.isNotEmpty && 
                    statusController.text.isNotEmpty && locationController.text.isNotEmpty) {
                  final newOrder = {
                    'id': orderIdController.text,
                    'status': statusController.text,
                    'customer': customerController.text,
                    'items': [],
                    'orderDate': DateTime.now(),
                    'estimatedDelivery': DateTime.now().add(const Duration(days: 3)),
                    'currentLocation': locationController.text,
                    'trackingEvents': [
                      {
                        'status': statusController.text,
                        'location': locationController.text,
                        'timestamp': DateTime.now(),
                        'description': descriptionController.text,
                      }
                    ],
                  };
                  
                  setState(() {
                    _orders.add(newOrder);
                    _filteredOrders = [..._orders];
                  });
                }
              } else {
                // Add event to existing order
                if (statusController.text.isNotEmpty && locationController.text.isNotEmpty) {
                  final newEvent = {
                    'status': statusController.text,
                    'location': locationController.text,
                    'timestamp': DateTime.now(),
                    'description': descriptionController.text,
                  };
                  
                  setState(() {
                    order['trackingEvents'].add(newEvent);
                    order['status'] = statusController.text;
                    order['currentLocation'] = locationController.text;
                  });
                }
              }
              Navigator.pop(context);
            },
            child: Text(isNewOrder ? 'CREATE' : 'ADD'),
          ),
        ],
      ),
    );
  }

  void _showUpdateStatusDialog(Map<String, dynamic> order) {
    final statusController = TextEditingController(text: order['status']);
    final locationController = TextEditingController(text: order['currentLocation']);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: order['status'],
              decoration: const InputDecoration(labelText: 'Status'),
              items: [
                'Processing',
                'Order Processed',
                'Shipped',
                'In Transit',
                'Out for Delivery',
                'Delivered',
                'Cancelled',
              ].map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  statusController.text = value;
                }
              },
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Current Location'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              if (statusController.text.isNotEmpty && locationController.text.isNotEmpty) {
                setState(() {
                  order['status'] = statusController.text;
                  order['currentLocation'] = locationController.text;
                  
                  // Add a new tracking event
                  order['trackingEvents'].add({
                    'status': statusController.text,
                    'location': locationController.text,
                    'timestamp': DateTime.now(),
                    'description': 'Status updated to ${statusController.text}',
                  });
                });
                
                Navigator.pop(context);
              }
            },
            child: const Text('UPDATE'),
          ),
        ],
      ),
    );
  }

  void _showDeleteEventDialog(Map<String, dynamic> order, Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Tracking Event'),
        content: const Text('Are you sure you want to delete this tracking event? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                (order['trackingEvents'] as List).remove(event);
                
                // Update status to previous event if available
                if ((order['trackingEvents'] as List).isNotEmpty) {
                  final lastEvent = (order['trackingEvents'] as List).last;
                  order['status'] = lastEvent['status'];
                  order['currentLocation'] = lastEvent['location'];
                }
              });
              Navigator.pop(context);
            },
            child: const Text(
              'DELETE',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
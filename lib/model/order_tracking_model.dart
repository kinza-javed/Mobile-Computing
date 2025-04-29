class TrackingEvent {
  final String status;
  final String location;
  final DateTime timestamp;
  final String description;

  TrackingEvent({
    required this.status,
    required this.location,
    required this.timestamp,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'location': location,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'description': description,
    };
  }

  factory TrackingEvent.fromMap(Map<String, dynamic> map) {
    return TrackingEvent(
      status: map['status'] ?? '',
      location: map['location'] ?? '',
      timestamp: map['timestamp'] is DateTime 
          ? map['timestamp'] 
          : DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      description: map['description'] ?? '',
    );
  }
}

class OrderItem {
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      name: map['name'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: map['price'] ?? 0.0,
    );
  }
}

class Order {
  final String id;
  String status;
  final String customer;
  final String email;
  final String phone;
  final String address;
  final List<OrderItem> items;
  final DateTime orderDate;
  DateTime estimatedDelivery;
  String currentLocation;
  final List<TrackingEvent> trackingEvents;

  Order({
    required this.id,
    required this.status,
    required this.customer,
    required this.email,
    required this.phone,
    required this.address,
    required this.items,
    required this.orderDate,
    required this.estimatedDelivery,
    required this.currentLocation,
    required this.trackingEvents,
  });

  double get totalAmount {
    return items.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  void addTrackingEvent(TrackingEvent event) {
    trackingEvents.add(event);
    status = event.status;
    currentLocation = event.location;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'customer': customer,
      'email': email,
      'phone': phone,
      'address': address,
      'items': items.map((item) => item.toMap()).toList(),
      'orderDate': orderDate.millisecondsSinceEpoch,
      'estimatedDelivery': estimatedDelivery.millisecondsSinceEpoch,
      'currentLocation': currentLocation,
      'trackingEvents': trackingEvents.map((event) => event.toMap()).toList(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] ?? '',
      status: map['status'] ?? '',
      customer: map['customer'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      items: List<OrderItem>.from(
        (map['items'] ?? []).map((item) => OrderItem.fromMap(item)),
      ),
      orderDate: map['orderDate'] is DateTime 
          ? map['orderDate'] 
          : DateTime.fromMillisecondsSinceEpoch(map['orderDate']),
      estimatedDelivery: map['estimatedDelivery'] is DateTime 
          ? map['estimatedDelivery'] 
          : DateTime.fromMillisecondsSinceEpoch(map['estimatedDelivery']),
      currentLocation: map['currentLocation'] ?? '',
      trackingEvents: List<TrackingEvent>.from(
        (map['trackingEvents'] ?? []).map((event) => TrackingEvent.fromMap(event)),
      ),
    );
  }
}

class TrackingService {
  // Dummy implementation for now, will be replaced with actual database later
  static final List<Order> _orders = [];

  // Add a sample order for testing
  static void initSampleData() {
    if (_orders.isEmpty) {
      final sampleOrder = Order(
        id: '123456',
        status: 'Processing',
        customer: 'John Doe',
        email: 'john@example.com',
        phone: '+1234567890',
        address: '123 Main St, Anytown, USA',
        items: [
          OrderItem(name: 'Red Roses Bouquet', quantity: 1, price: 49.99),
          OrderItem(name: 'Chocolate Box', quantity: 1, price: 15.99),
        ],
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        estimatedDelivery: DateTime.now().add(const Duration(days: 3)),
        currentLocation: 'Warehouse',
        trackingEvents: [
          TrackingEvent(
            status: 'Order Placed',
            location: 'Online',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            description: 'Your order has been received and is being processed.',
          ),
        ],
      );
      _orders.add(sampleOrder);
    }
  }

  // Get all orders
  static List<Order> getAllOrders() {
    return _orders;
  }

  // Get order by ID
  static Order? getOrderById(String id) {
    try {
      return _orders.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  // Add new order
  static void addOrder(Order order) {
    _orders.add(order);
  }

  // Update order status and add tracking event
  static void updateOrderStatus(
    String orderId, 
    String status, 
    String location, 
    String description,
  ) {
    final order = getOrderById(orderId);
    if (order != null) {
      final event = TrackingEvent(
        status: status,
        location: location,
        timestamp: DateTime.now(),
        description: description,
      );
      order.addTrackingEvent(event);
    }
  }

  // Delete order
  static void deleteOrder(String id) {
    _orders.removeWhere((order) => order.id == id);
  }
}
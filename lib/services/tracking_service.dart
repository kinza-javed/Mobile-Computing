//import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_application_1/model/order_tracking_model.dart';

class TrackingServiceImpl {
  // Local storage key
  static const String _ordersKey = 'tracking_orders';
  
  // In-memory cache
  List<Order> _ordersCache = [];

  // Singleton instance
  static final TrackingServiceImpl _instance = TrackingServiceImpl._internal();
  
  // Factory constructor
  factory TrackingServiceImpl() {
    return _instance;
  }
  
  // Private constructor
  TrackingServiceImpl._internal();
  
  // Initialize the service
  Future<void> initialize() async {
    await _loadOrders();
    
    // Add sample data if no orders exist
    if (_ordersCache.isEmpty) {
      await _addSampleData();
    }
  }

  // Load orders from local storage
  Future<void> _loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = prefs.getString(_ordersKey);
      
      if (ordersJson != null) {
        final List<dynamic> decoded = jsonDecode(ordersJson);
        _ordersCache = decoded.map((item) => Order.fromMap(item)).toList();
      }
    } catch (e) {
      print('Error loading orders: $e');
      _ordersCache = [];
    }
  }

  // Save orders to local storage
  Future<void> _saveOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = jsonEncode(_ordersCache.map((order) => order.toMap()).toList());
      await prefs.setString(_ordersKey, ordersJson);
    } catch (e) {
      print('Error saving orders: $e');
    }
  }

  // Add sample data for testing
  Future<void> _addSampleData() async {
    final sampleOrders = [
      Order(
        id: '123456',
        status: 'In Transit',
        customer: 'John Doe',
        email: 'john.doe@example.com',
        phone: '+1234567890',
        address: '123 Main St, Anytown, USA',
        items: [
          OrderItem(name: 'Red Roses Bouquet', quantity: 1, price: 49.99),
          OrderItem(name: 'Chocolate Box', quantity: 1, price: 15.99),
        ],
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        estimatedDelivery: DateTime.now().add(const Duration(days: 1)),
        currentLocation: 'Local Distribution Center',
        trackingEvents: [
          TrackingEvent(
            status: 'Order Placed',
            location: 'Online',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            description: 'Your order has been received and is being processed.',
          ),
          TrackingEvent(
            status: 'Order Processed',
            location: 'Warehouse',
            timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 12)),
            description: 'Your order has been prepared and packaged.',
          ),
          TrackingEvent(
            status: 'In Transit',
            location: 'Local Distribution Center',
            timestamp: DateTime.now().subtract(const Duration(hours: 6)),
            description: 'Your order is on its way to you.',
          ),
        ],
      ),
      Order(
        id: '789012',
        status: 'Processing',
        customer: 'Jane Smith',
        email: 'jane.smith@example.com',
        phone: '+0987654321',
        address: '456 Oak Ave, Somewhere, USA',
        items: [
          OrderItem(name: 'Birthday Gift Basket', quantity: 1, price: 79.99),
        ],
        orderDate: DateTime.now().subtract(const Duration(hours: 12)),
        estimatedDelivery: DateTime.now().add(const Duration(days: 3)),
        currentLocation: 'Warehouse',
        trackingEvents: [
          TrackingEvent(
            status: 'Order Placed',
            location: 'Online',
            timestamp: DateTime.now().subtract(const Duration(hours: 12)),
            description: 'Your order has been received and is being processed.',
          ),
        ],
      ),
    ];
    
    _ordersCache.addAll(sampleOrders);
    await _saveOrders();
  }

  // Get all orders
  List<Order> getAllOrders() {
    return _ordersCache;
  }

  // Get order by ID
  Order? getOrderById(String id) {
    try {
      return _ordersCache.firstWhere((order) => order.id == id);
    } catch (e) {
      return null;
    }
  }

  // Create new order
  Future<void> createOrder(Order order) async {
    _ordersCache.add(order);
    await _saveOrders();
  }

  // Update order status and add tracking event
  Future<void> updateOrderStatus(
    String orderId, 
    String status, 
    String location, 
    String description,
  ) async {
    final order = getOrderById(orderId);
    if (order != null) {
      final event = TrackingEvent(
        status: status,
        location: location,
        timestamp: DateTime.now(),
        description: description,
      );
      order.addTrackingEvent(event);
      await _saveOrders();
    }
  }

  // Update order details
  Future<void> updateOrder(Order updatedOrder) async {
    final index = _ordersCache.indexWhere((order) => order.id == updatedOrder.id);
    if (index != -1) {
      _ordersCache[index] = updatedOrder;
      await _saveOrders();
    }
  }

  // Delete order
  Future<void> deleteOrder(String id) async {
    _ordersCache.removeWhere((order) => order.id == id);
    await _saveOrders();
  }

  // Generate a new order ID
  String generateOrderId() {
    // Simple sequential ID generation
    if (_ordersCache.isEmpty) {
      return '100001';
    }
    
    // Find highest ID and increment
    int highestId = 0;
    for (var order in _ordersCache) {
      final int orderId = int.tryParse(order.id) ?? 0;
      if (orderId > highestId) {
        highestId = orderId;
      }
    }
    
    return (highestId + 1).toString();
  }
}
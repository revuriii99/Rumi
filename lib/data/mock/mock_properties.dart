import 'package:rumi/data/models/property_model.dart';
// ignore: unused_import
import 'package:flutter/material.dart';

List<PropertyModel> mockProperties = [
  PropertyModel(
    id: '1',
    name: 'Kost Azzahra Akordion',
    location: 'Tunggulwulung, Malang',
    price: 1500000,
    rating: 8.9,
    imageUrl:
        'https://rumahhalalnusantara.com/wp-content/uploads/2021/12/azzahra-tipe70.jpg',
    facilities: ['Kamar Mandi Dalam', 'WiFi', 'Parkir Motor', 'Dapur Bersama'],
    description: 'Kos nyaman dengan lingkungan tenang, 5 menit ke kampus.',
  ),
  PropertyModel(
    id: '2',
    name: 'Kost Ambasing sigura gura',
    location: 'Ngawi, Malang',
    price: 2000000,
    rating: 10.0,
    imageUrl: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688',
    facilities: ['AC', 'Water Heater', 'Gym', 'Kolam Renang', 'Laundry Gratis'],
    description: 'Unit Studio modern siap huni di pusat keramaian',
  ),
];

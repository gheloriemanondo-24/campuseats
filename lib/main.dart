import 'package:flutter/material.dart';

import 'app_theme.dart';
import 'viewmodels/order_view_model.dart';
import 'views/home_screen.dart';

void main() => runApp(CampusEatsApp(store: OrderViewModel()));

class CampusEatsApp extends StatelessWidget {
  const CampusEatsApp({super.key, required this.store});

  final OrderViewModel store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusEats',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      home: HomeScreen(store: store),
    );
  }
}

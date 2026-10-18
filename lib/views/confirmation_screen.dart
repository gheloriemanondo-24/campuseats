import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/models.dart';
import '../widgets.dart';

class ConfirmationScreen extends StatelessWidget {
  const ConfirmationScreen({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                children: [
                  const TopBar(),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Icon(Icons.check_circle, color: AppColors.green, size: 30),
                      SizedBox(width: 10),
                      Text(
                        'Order placed',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ready for pickup at ${formatTime(order.pickup)}',
                    style: const TextStyle(
                      fontSize: 17,
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _Ticket(order: order),
                  const SizedBox(height: 16),
                  const Text(
                    'Show this number at the counter when you arrive.',
                    style: TextStyle(fontSize: 14, color: AppColors.muted),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: BigButton(
                label: 'DONE',
                kind: BigButtonKind.dark,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Ticket extends StatelessWidget {
  const _Ticket({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ink, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(child: SectionLabel('Order number')),
                    Text(
                      order.place.name,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  order.label,
                  style: const TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -2,
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: DashedDivider(),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionLabel('Pickup'),
                const SizedBox(height: 4),
                Text(
                  formatTime(order.pickup),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 18),
                const SectionLabel('Items'),
                const SizedBox(height: 6),
                for (final line in order.lines)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '${line.qty} x ${line.name}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

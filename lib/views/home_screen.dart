import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models/models.dart';
import '../viewmodels/order_view_model.dart';
import '../widgets.dart';
import 'confirmation_screen.dart';
import 'order_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.store});

  final OrderViewModel store;

  void _order(BuildContext context) {
    store.startOrder();
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => OrderScreen(store: store)),
    );
  }

  void _track(BuildContext context) {
    final order = store.lastOrder;
    if (order == null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('No active order yet. Place one first.')),
        );
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ConfirmationScreen(order: order),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            final active = store.lastOrder;
            return ListView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
              children: [
                const TopBar(),
                const SizedBox(height: 36),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Skip the line.\n'),
                      TextSpan(
                        text: 'Order ahead.',
                        style: TextStyle(color: AppColors.tomato),
                      ),
                    ],
                  ),
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    height: 1.05,
                    letterSpacing: -1.2,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Pick a stall, set a pickup time, and walk straight to the '
                  'counter when it is ready.',
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 28),
                BigButton(
                  label: 'ORDER FOOD',
                  onPressed: () => _order(context),
                ),
                const SizedBox(height: 12),
                BigButton(
                  label: 'TRACK MY ORDER',
                  kind: BigButtonKind.outline,
                  onPressed: () => _track(context),
                ),
                if (active != null) ...[
                  const SizedBox(height: 16),
                  _ActiveOrderStrip(
                    order: active,
                    onTap: () => _track(context),
                  ),
                ],
                const SizedBox(height: 36),
                const SectionLabel('Nearby locations'),
                const SizedBox(height: 10),
                for (final place in kPlaces)
                  _PlaceRow(
                    place: place,
                    selected: place == store.selectedPlace,
                    onTap: () => store.selectPlace(place),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PlaceRow extends StatelessWidget {
  const _PlaceRow({
    required this.place,
    required this.selected,
    required this.onTap,
  });

  final Place place;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: selected ? AppColors.card : Colors.transparent,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: selected ? AppColors.ink : AppColors.rule,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  size: 22,
                  color: selected ? AppColors.tomato : AppColors.muted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                WaitChip(minutes: place.waitMinutes),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActiveOrderStrip extends StatelessWidget {
  const _ActiveOrderStrip({required this.order, required this.onTap});

  final Order order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.tomatoSoft,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const Icon(Icons.receipt_long, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Order ${order.label} at ${order.place.name}, '
                  'pickup ${formatTime(order.pickup)}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}

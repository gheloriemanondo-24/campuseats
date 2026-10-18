import 'dart:math' as math;

// food stall students can order from
class Place {
  const Place({
    required this.name,
    required this.waitMinutes,
    required this.menu,
  });

  final String name;
  final int waitMinutes;
  final List<String> menu;
}

// sample data A real app would load this from a server
const List<Place> kPlaces = [
  Place(
    name: 'BURP',
    waitMinutes: 8,
    menu: [
      'Chicken Burger',
      'Chicken Fillet with Rice',
      'Crinkle Fries',
      'Iced Tea',
    ],
  ),
  Place(
    name: 'Library Cafe',
    waitMinutes: 3,
    menu: ['Tuna Sandwich', 'Iced Coffee', 'Fruit Cup', 'Blueberry Muffin'],
  ),
];

// one row in the cart: an item name and how many
class CartLine {
  CartLine(this.name, [this.qty = 1]);

  final String name;
  int qty;
}

// a placed order lines are a snapshot, so later cart edits do not change it
class Order {
  const Order({
    required this.number,
    required this.place,
    required this.pickup,
    required this.lines,
  });

  final int number;
  final Place place;
  final DateTime pickup;
  final List<CartLine> lines;

  String get label => '#${number.toString().padLeft(4, '0')}';

  int get itemCount => lines.fold<int>(0, (sum, line) => sum + line.qty);
}

//12-hour clock, example "12:40 PM"
String formatTime(DateTime t) {
  final hour = t.hour % 12 == 0 ? 12 : t.hour % 12;
  final minute = t.minute.toString().padLeft(2, '0');
  final suffix = t.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $suffix';
}

// whole minutes from now until [t], never less than 1
int minutesUntil(DateTime t) {
  return math.max(1, t.difference(DateTime.now()).inMinutes);
}

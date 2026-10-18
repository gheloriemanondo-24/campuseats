import 'package:flutter/foundation.dart';

import '../models/models.dart';

class OrderViewModel extends ChangeNotifier {
  Place _selectedPlace = kPlaces.first;
  List<CartLine> _cart = [];
  List<DateTime> _slots = [];
  DateTime? _pickup;
  Order? _lastOrder;
  int _nextNumber = 1;

  Place get selectedPlace => _selectedPlace;
  List<CartLine> get cart => List.unmodifiable(_cart);
  List<DateTime> get slots => List.unmodifiable(_slots);
  DateTime? get pickup => _pickup;
  Order? get lastOrder => _lastOrder;
  int get itemCount => _cart.fold<int>(0, (sum, line) => sum + line.qty);

  void selectPlace(Place place) {
    _selectedPlace = place;
    notifyListeners();
  }

  // called when the student taps "Order food" Starts a fresh cart
  // pre-filled with the stall's first two dishes like the mockup
  // and builds fresh pickup slots
  void startOrder() {
    final menu = _selectedPlace.menu;
    _cart = [CartLine(menu[0]), CartLine(menu[1])];
    _slots = _buildSlots(_selectedPlace);
    _pickup = _slots.first;
    notifyListeners();
  }

  void changeQty(CartLine line, int delta) {
    final next = line.qty + delta;
    if (next < 1 || next > 9) return;
    line.qty = next;
    notifyListeners();
  }

  // removes line and returns the index it had, so Undo can put it back
  int removeLine(CartLine line) {
    final index = _cart.indexOf(line);
    if (index == -1) return -1;
    _cart.removeAt(index);
    notifyListeners();
    return index;
  }

  void restoreLine(int index, CartLine line) {
    if (index < 0) return;
    final at = index > _cart.length ? _cart.length : index;
    _cart.insert(at, line);
    notifyListeners();
  }

  void addItem(String name) {
    for (final line in _cart) {
      if (line.name == name) {
        changeQty(line, 1);
        return;
      }
    }
    _cart.add(CartLine(name));
    notifyListeners();
  }

  void setPickup(DateTime time) {
    _pickup = time;
    notifyListeners();
  }

  Order placeOrder() {
    final order = Order(
      number: _nextNumber++,
      place: _selectedPlace,
      pickup: _pickup!,
      lines: _cart.map((l) => CartLine(l.name, l.qty)).toList(),
    );
    _lastOrder = order;
    notifyListeners();
    return order;
  }

  // six slots, five minutes apart, starting after the stall's current wait
  List<DateTime> _buildSlots(Place place) {
    final now = DateTime.now();
    final earliest = now.add(Duration(minutes: place.waitMinutes + 5));
    final first = DateTime(
      earliest.year,
      earliest.month,
      earliest.day,
      earliest.hour,
      ((earliest.minute + 4) ~/ 5) * 5,
    );
    return List.generate(6, (i) => first.add(Duration(minutes: 5 * i)));
  }
}

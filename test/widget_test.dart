import 'package:flutter_test/flutter_test.dart';

import 'package:campuseats/main.dart';
import 'package:campuseats/viewmodels/order_view_model.dart';

void main() {
  testWidgets('CampusEats opens the ordering screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(CampusEatsApp(store: OrderViewModel()));

    expect(find.text('ORDER FOOD'), findsOneWidget);
    expect(find.text('TRACK MY ORDER'), findsOneWidget);

    await tester.tap(find.text('ORDER FOOD'));
    await tester.pumpAndSettle();

    expect(find.text('ORDERING FROM'), findsOneWidget);
    expect(find.text('YOUR ORDER'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:hotel_app/main.dart';

void main() {
  testWidgets('StayEase app loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const StayEaseApp());

    // Allow the 3-second splash timer to complete.
    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(StayEaseApp), findsOneWidget);
  });
}
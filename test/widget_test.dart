import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('renders the landing page', (WidgetTester tester) async {
    await tester.pumpWidget(const LocalCouponsApp());

    expect(find.text('Local Coupons'), findsWidgets);
    expect(find.text('Discover the best offers near you.'), findsOneWidget);
    expect(find.text('Browse coupons'), findsOneWidget);
  });
}

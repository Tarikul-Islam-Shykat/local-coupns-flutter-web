import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('renders the login page', (WidgetTester tester) async {
    await tester.pumpWidget(const LocalCouponsApp());
    await tester.pumpAndSettle();

    expect(find.text('Log in your Account'), findsOneWidget);
    expect(
      find.text('Welcome back! Please enter your details.'),
      findsOneWidget,
    );
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Log In'), findsOneWidget);
  });
}

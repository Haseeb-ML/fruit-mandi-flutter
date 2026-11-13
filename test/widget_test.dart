import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_mandi_app/main.dart';

void main() {
  testWidgets('App renders login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FruitMandiApp());
    expect(find.text('Fruit Mandi System'), findsOneWidget);
  });
}

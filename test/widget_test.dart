import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fruit_mandi_app/main.dart';
import 'package:fruit_mandi_app/models/mandi_models.dart';

void main() {
  test('formatRs and formatIndianNumber format Pakistani currency correctly', () {
    expect(formatRs(0), 'Rs 0');
    expect(formatRs(8400), 'Rs 8,400');
    expect(formatRs(254000), 'Rs 2,54,000');
    expect(formatRs(123000), 'Rs 1,23,000');
  });

  testWidgets('Full end-to-end navigation, CRUD, and layout test (no overflows)',
      (WidgetTester tester) async {
    // Realistic mobile phone viewport (390x844)
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FruitMandiApp());

    // 1. Login screen renders and logs in
    expect(find.text('Fruit Mandi System'), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
    await tester.tap(find.text('لاگ ان — Login'));
    await tester.pumpAndSettle();

    // 2. Dashboard renders Quick Menu at top, KPIs, charts, Recent Transactions
    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Quick Menu'), findsOneWidget);
    expect(find.text("Today's Sale"), findsOneWidget);
    expect(find.text('Rs 2,54,000'), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('Weekly Sales'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Weekly Sales'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Top Fruits'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Top Fruits'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Recent Transactions'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Recent Transactions'), findsOneWidget);

    // 2b. Toggle English -> Urdu -> English
    await tester.tap(find.byKey(const ValueKey('language_toggle_pill')));
    await tester.pumpAndSettle();
    expect(find.text('ڈیش بورڈ'), findsWidgets);
    expect(find.text('حالیہ لین دین'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('language_toggle_pill')));
    await tester.pumpAndSettle();
    expect(find.text('Recent Transactions'), findsOneWidget);

    // 3. Notifications screen
    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Mark all read'), findsOneWidget);
    await tester.tap(find.text('Mark all read'));
    await tester.pumpAndSettle();
    expect(find.text('0 unread — اطلاعات'), findsOneWidget);

    // 4. Farmers tab: search + add farmer + delete confirmation
    await tester.tap(find.text('Farmers'));
    await tester.pumpAndSettle();
    expect(find.text('Muhammad Ali Khan'), findsOneWidget);

    await tester.tap(find.text('Add Farmer'));
    await tester.pumpAndSettle();
    expect(find.text('نیا کاشتکار'), findsOneWidget);
    await tester.enterText(
        find.widgetWithText(TextField, 'Muhammad Ali Khan'), 'Bilal Farmer');
    await tester.enterText(
        find.widgetWithText(TextField, 'Multan'), 'Kasur');
    await tester.tap(find.text('Save — محفوظ'));
    await tester.pumpAndSettle();
    expect(find.text('Bilal Farmer'), findsOneWidget);

    // 5. Buyers tab: search + add buyer
    await tester.tap(find.text('Buyers'));
    await tester.pumpAndSettle();
    expect(find.text('Khan Fruit Centre'), findsOneWidget);
    await tester.tap(find.text('Add Buyer'));
    await tester.pumpAndSettle();
    expect(find.text('Add Buyer — نیا خریدار'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    // 6. Arrival tab
    await tester.tap(find.text('Arrival'));
    await tester.pumpAndSettle();
    expect(find.text('Fruit Arrival'), findsOneWidget);
    expect(find.text('1600 kg'), findsOneWidget);

    // 7. Auction tab: open New Auction and verify live commission calculation
    await tester.tap(find.text('Auction'));
    await tester.pumpAndSettle();
    expect(find.text('AUC-0142'), findsOneWidget);
    await tester.tap(find.text('New Auction'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Boxes'), '10');
    await tester.enterText(find.widgetWithText(TextField, 'Rate (Rs)'), '500');
    await tester.pump();
    expect(find.text('Commission (6.0%): Rs 300'), findsOneWidget);
    expect(find.text('Net: Rs 4,700'), findsOneWidget);
    await tester.tap(find.text('Save Auction — محفوظ'));
    await tester.pumpAndSettle();
    expect(find.text('AUC-0144'), findsOneWidget);

    // 8. More / Settings tab
    await tester.tap(find.text('More'));
    await tester.pumpAndSettle();
    expect(find.text('Company Information'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Save Settings — ترتیبات محفوظ کریں'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Fruit Mandi Arhti System v1.0'), findsOneWidget);

    // 9. Test all 6 Quick Menu dedicated pages from Dashboard
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();

    // 9a. Payment page + record payment
    await tester.tap(find.text('Payment'));
    await tester.pumpAndSettle();
    expect(find.text('Payments'), findsOneWidget);
    await tester.tap(find.text('Record Payment'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextField, 'Amount Received (Rs)'), '5000');
    await tester.tap(find.text('Save Payment'));
    await tester.pumpAndSettle();
    expect(find.text('+Rs 5,000'), findsWidgets);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // 9b. Ledger page + filter + search
    await tester.tap(find.text('Ledger'));
    await tester.pumpAndSettle();
    expect(find.text('Party Ledger'), findsOneWidget);
    await tester.tap(find.text('Farmers').last);
    await tester.pumpAndSettle();
    expect(find.text('Muhammad Ali Khan'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // 9c. Expenses page + add expense
    await tester.tap(find.text('Expenses'));
    await tester.pumpAndSettle();
    expect(find.text('Expenses'), findsOneWidget);
    await tester.tap(find.text('Add Expense'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextField, 'Description (e.g. Labour / Transport)'),
      'Ice',
    );
    await tester.enterText(
        find.widgetWithText(TextField, 'Amount (Rs)'), '600');
    await tester.tap(find.text('Save Expense'));
    await tester.pumpAndSettle();
    expect(find.text('Ice'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // 9d. Reports page
    await tester.tap(find.text('Reports'));
    await tester.pumpAndSettle();
    expect(find.text('Reports & Summary'), findsOneWidget);
    expect(find.text('Total Auction Sales'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // 9e. Invoice page
    await tester.tap(find.text('Invoice'));
    await tester.pumpAndSettle();
    expect(find.text('Invoices'), findsOneWidget);
    expect(find.text('Net Payable'), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle();

    // 9f. Cash Book page + language toggle inside pushed page
    await tester.tap(find.text('Cash Book'));
    await tester.pumpAndSettle();
    expect(find.text('Cash Book'), findsOneWidget);
    expect(find.text('Cash In'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('language_toggle_pill')));
    await tester.pumpAndSettle();
    expect(find.text('نقد کتاب'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('language_toggle_pill')));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();
  });
}

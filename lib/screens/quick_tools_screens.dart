import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_lang.dart';
import '../models/mandi_models.dart';

class _ToolScaffold extends StatelessWidget {
  final String titleEn;
  final String titleUr;
  final Widget body;
  final Widget? floatingActionButton;

  const _ToolScaffold({
    required this.titleEn,
    required this.titleUr,
    required this.body,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    final isUr = AppLang.isUrdu(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isUr ? titleUr : titleEn,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            Text(
              isUr ? titleEn : titleUr,
              style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: LanguageTogglePill()),
          ),
        ],
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}

// 1. PAYMENT SCREEN
class PaymentScreen extends StatefulWidget {
  final List<Buyer> buyers;
  final List<MandiTransaction> transactions;
  final void Function(String buyerId, int amount) onRecordPayment;

  const PaymentScreen({
    super.key,
    required this.buyers,
    required this.transactions,
    required this.onRecordPayment,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  void _openRecordModal() {
    if (widget.buyers.isEmpty) return;
    String buyerId = widget.buyers.first.id;
    final amtCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLang.t(ctx, 'Record Payment', 'ادائیگی درج کریں'),
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                isExpanded: true,
                initialValue: buyerId,
                decoration: InputDecoration(
                  labelText: AppLang.t(ctx, 'Buyer', 'خریدار'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                items: widget.buyers
                    .map((b) => DropdownMenuItem(
                          value: b.id,
                          child: Text(
                            '${b.businessName} (${formatRs(b.outstanding)})',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setS(() => buyerId = v);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: amtCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText:
                      AppLang.t(ctx, 'Amount Received (Rs)', 'وصول شدہ رقم'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final amt = int.tryParse(amtCtrl.text.trim()) ?? 0;
                    if (amt <= 0) return;
                    widget.onRecordPayment(buyerId, amt);
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0E7C3A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(AppLang.t(ctx, 'Save Payment', 'محفوظ کریں')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUr = AppLang.isUrdu(context);
    final totalPending =
        widget.buyers.fold<int>(0, (s, b) => s + b.outstanding);
    final payments =
        widget.transactions.where((t) => t.category == 'payment').toList();

    return _ToolScaffold(
      titleEn: 'Payments',
      titleUr: 'ادائیگیاں',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openRecordModal,
        backgroundColor: const Color(0xFF0E7C3A),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(isUr ? 'ادائیگی درج کریں' : 'Record Payment'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0E7C3A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isUr ? 'کل واجب الادا رقم' : 'Total Receivable',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatRs(totalPending),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.payments_outlined,
                    color: Colors.white70, size: 34),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isUr ? 'خریداروں کا بقایا' : 'Buyer Balances',
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827)),
          ),
          const SizedBox(height: 8),
          ...widget.buyers.map((b) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(b.businessName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                          Text(b.contactName,
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFF6B7280))),
                        ],
                      ),
                    ),
                    Text(
                      formatRs(b.outstanding),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: b.outstanding > 0
                            ? const Color(0xFFC2410C)
                            : const Color(0xFF0E7C3A),
                      ),
                    ),
                  ],
                ),
              )),
          if (payments.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              isUr ? 'حالیہ وصولیاں' : 'Recent Payments',
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827)),
            ),
            const SizedBox(height: 8),
            ...payments.map((p) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline,
                          color: Color(0xFF0E7C3A), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.5)),
                            Text(p.subtitle,
                                style: const TextStyle(
                                    fontSize: 11.5, color: Color(0xFF6B7280))),
                          ],
                        ),
                      ),
                      Text(
                        '+${formatRs(p.amount)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0E7C3A),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ],
      ),
    );
  }
}

// 2. LEDGER SCREEN
class LedgerScreen extends StatefulWidget {
  final List<Farmer> farmers;
  final List<Buyer> buyers;

  const LedgerScreen({
    super.key,
    required this.farmers,
    required this.buyers,
  });

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  String _filter = 'all'; // all, buyers, farmers
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final isUr = AppLang.isUrdu(context);
    final showBuyers = _filter == 'all' || _filter == 'buyers';
    final showFarmers = _filter == 'all' || _filter == 'farmers';

    final filteredBuyers = widget.buyers
        .where((b) =>
            b.businessName.toLowerCase().contains(_query.toLowerCase()) ||
            b.contactName.toLowerCase().contains(_query.toLowerCase()))
        .toList();
    final filteredFarmers = widget.farmers
        .where((f) =>
            f.name.toLowerCase().contains(_query.toLowerCase()) ||
            f.village.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return _ToolScaffold(
      titleEn: 'Party Ledger',
      titleUr: 'کھاتہ',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            onChanged: (v) => setState(() => _query = v),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
              hintText: isUr ? 'نام سے تلاش کریں...' : 'Search party...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ChipBtn(
                label: isUr ? 'سب' : 'All',
                selected: _filter == 'all',
                onTap: () => setState(() => _filter = 'all'),
              ),
              _ChipBtn(
                label: isUr ? 'خریدار' : 'Buyers',
                selected: _filter == 'buyers',
                onTap: () => setState(() => _filter = 'buyers'),
              ),
              _ChipBtn(
                label: isUr ? 'کاشتکار' : 'Farmers',
                selected: _filter == 'farmers',
                onTap: () => setState(() => _filter = 'farmers'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (showBuyers)
            ...filteredBuyers.map((b) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.storefront_outlined,
                            color: Color(0xFF2563EB), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(b.businessName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(
                              '${isUr ? 'حد' : 'Limit'}: ${formatRs(b.creditLimit)}',
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatRs(b.outstanding),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: b.outstanding > 0
                                  ? const Color(0xFFDC2626)
                                  : const Color(0xFF0E7C3A),
                            ),
                          ),
                          Text(
                            isUr ? 'بقایا' : 'Outstanding',
                            style: const TextStyle(
                                fontSize: 11, color: Color(0xFF9CA3AF)),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          if (showFarmers)
            ...filteredFarmers.map((f) => Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.agriculture_outlined,
                            color: Color(0xFF0E7C3A), size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(
                              '${f.village} · ${f.fruit}',
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            formatRs(f.balance),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0E7C3A),
                            ),
                          ),
                          Text(
                            isUr ? 'کھاتہ بیلنس' : 'Balance',
                            style: const TextStyle(
                                fontSize: 11, color: Color(0xFF9CA3AF)),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
        ],
      ),
    );
  }
}

// 3. EXPENSES SCREEN
class ExpensesScreen extends StatefulWidget {
  final int totalExpenses;
  final List<MandiTransaction> transactions;
  final void Function(String title, int amount) onAddExpense;

  const ExpensesScreen({
    super.key,
    required this.totalExpenses,
    required this.transactions,
    required this.onAddExpense,
  });

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  void _openAddModal() {
    final titleCtrl = TextEditingController();
    final amtCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLang.t(ctx, 'Add Expense', 'اخراجات شامل کریں'),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                labelText: AppLang.t(
                  ctx,
                  'Description (e.g. Labour / Transport)',
                  'تفصیل (مثلاً مزدوری / کرایہ)',
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amtCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: AppLang.t(ctx, 'Amount (Rs)', 'رقم (روپے)'),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final amt = int.tryParse(amtCtrl.text.trim()) ?? 0;
                  if (titleCtrl.text.trim().isEmpty || amt <= 0) return;
                  widget.onAddExpense(titleCtrl.text.trim(), amt);
                  Navigator.pop(ctx);
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0E7C3A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(AppLang.t(ctx, 'Save Expense', 'محفوظ کریں')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUr = AppLang.isUrdu(context);
    final expItems =
        widget.transactions.where((t) => t.category == 'expense').toList();

    return _ToolScaffold(
      titleEn: 'Expenses',
      titleUr: 'اخراجات',
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddModal,
        backgroundColor: const Color(0xFFE11D48),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(isUr ? 'نیا خرچہ' : 'Add Expense'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFECDD3)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isUr ? 'آج کے کل اخراجات' : "Today's Total Expenses",
                        style: const TextStyle(
                            color: Color(0xFF9F1239), fontSize: 12),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatRs(widget.totalExpenses),
                        style: const TextStyle(
                          color: Color(0xFFBE123C),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.receipt_long_outlined,
                    color: Color(0xFFE11D48), size: 34),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isUr ? 'اخراجات کی فہرست' : 'Expense Entries',
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827)),
          ),
          const SizedBox(height: 8),
          ...expItems.map((e) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.arrow_upward_rounded,
                        color: Color(0xFFE11D48), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                          Text(e.subtitle,
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFF6B7280))),
                        ],
                      ),
                    ),
                    Text(
                      '-${formatRs(e.amount)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// 4. REPORTS SCREEN
class ReportsScreen extends StatelessWidget {
  final List<AuctionEntry> auctions;
  final List<ArrivalEntry> arrivals;
  final List<Buyer> buyers;
  final int totalExpenses;

  const ReportsScreen({
    super.key,
    required this.auctions,
    required this.arrivals,
    required this.buyers,
    required this.totalExpenses,
  });

  @override
  Widget build(BuildContext context) {
    final isUr = AppLang.isUrdu(context);
    final totalSales =
        auctions.fold<int>(0, (s, a) => s + a.boxes * a.rate);
    final totalCommission =
        auctions.fold<int>(0, (s, a) => s + a.commission);
    final totalBoxes = arrivals.fold<int>(0, (s, a) => s + a.boxes);
    final totalPending = buyers.fold<int>(0, (s, b) => s + b.outstanding);
    final netEarnings = totalCommission - totalExpenses;

    final Map<String, int> fruitTotals = {};
    for (final a in auctions) {
      fruitTotals[a.fruit] = (fruitTotals[a.fruit] ?? 0) + a.boxes * a.rate;
    }

    return _ToolScaffold(
      titleEn: 'Reports & Summary',
      titleUr: 'رپورٹس اور خلاصہ',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ReportStatTile(
            label: isUr ? 'کل نیلامی فروخت' : 'Total Auction Sales',
            value: formatRs(totalSales),
            color: const Color(0xFF0E7C3A),
            icon: Icons.trending_up_rounded,
          ),
          _ReportStatTile(
            label: isUr ? 'کل کمیشن آمدن' : 'Total Commission Earned',
            value: formatRs(totalCommission),
            color: const Color(0xFFC2410C),
            icon: Icons.monetization_on_outlined,
          ),
          _ReportStatTile(
            label: isUr ? 'کل اخراجات' : 'Total Expenses',
            value: formatRs(totalExpenses),
            color: const Color(0xFFE11D48),
            icon: Icons.receipt_long_outlined,
          ),
          _ReportStatTile(
            label: isUr ? 'خالص منافع' : 'Net Commission Profit',
            value: formatRs(netEarnings),
            color: const Color(0xFF1D4ED8),
            icon: Icons.account_balance_wallet_outlined,
          ),
          _ReportStatTile(
            label: isUr ? 'خریداروں کے ذمہ بقایا' : 'Pending Buyer Credit',
            value: formatRs(totalPending),
            color: const Color(0xFF7E22CE),
            icon: Icons.access_time_rounded,
          ),
          _ReportStatTile(
            label: isUr ? 'کل آمد (کریٹس)' : 'Total Arrival Boxes',
            value: '${formatIndianNumber(totalBoxes)} Boxes (${arrivals.length} Lots)',
            color: const Color(0xFF0F766E),
            icon: Icons.inventory_2_outlined,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isUr ? 'پھل کے حساب سے فروخت' : 'Sales by Fruit',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ...fruitTotals.entries.map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(e.key,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ),
                          Text(
                            formatRs(e.value),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0E7C3A),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportStatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _ReportStatTile({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13.5, color: Color(0xFF4B5563))),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                    fontSize: 14.5, fontWeight: FontWeight.bold, color: color),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 5. INVOICE SCREEN
class InvoiceScreen extends StatefulWidget {
  final List<AuctionEntry> auctions;
  final MandiSettings settings;

  const InvoiceScreen({
    super.key,
    required this.auctions,
    required this.settings,
  });

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  int _selectedIdx = 0;

  @override
  Widget build(BuildContext context) {
    final isUr = AppLang.isUrdu(context);
    if (widget.auctions.isEmpty) {
      return _ToolScaffold(
        titleEn: 'Invoices',
        titleUr: 'انوائس / بل',
        body: Center(
          child: Text(
            isUr ? 'کوئی نیلامی موجود نہیں' : 'No auction entries available',
          ),
        ),
      );
    }

    final auc = widget.auctions[_selectedIdx.clamp(0, widget.auctions.length - 1)];
    final gross = auc.boxes * auc.rate;
    final marketFee = (gross * (widget.settings.marketFeePercent / 100)).round();
    final netPayable = gross - auc.commission - marketFee;

    return _ToolScaffold(
      titleEn: 'Invoices',
      titleUr: 'انوائس / بل',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<int>(
            isExpanded: true,
            initialValue: _selectedIdx,
            decoration: InputDecoration(
              labelText: isUr ? 'نیلامی منتخب کریں' : 'Select Auction Lot',
              filled: true,
              fillColor: Colors.white,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
            items: List.generate(
              widget.auctions.length,
              (i) => DropdownMenuItem(
                value: i,
                child: Text(
                  '${widget.auctions[i].id} · ${widget.auctions[i].farmerName} → ${widget.auctions[i].buyerName}',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            onChanged: (v) {
              if (v != null) setState(() => _selectedIdx = v);
            },
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.settings.companyName,
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0E7C3A)),
                ),
                Text(
                  '${widget.settings.address} · ${widget.settings.phone}',
                  style:
                      const TextStyle(fontSize: 11.5, color: Color(0xFF6B7280)),
                ),
                const Divider(height: 24),
                _InvRow(isUr ? 'انوائس نمبر' : 'Invoice No', auc.id),
                _InvRow(isUr ? 'تاریخ' : 'Date', auc.date),
                _InvRow(isUr ? 'کاشتکار' : 'Farmer', auc.farmerName),
                _InvRow(isUr ? 'خریدار' : 'Buyer', auc.buyerName),
                _InvRow(isUr ? 'پھل / گریڈ' : 'Fruit / Grade',
                    '${auc.fruit} (${auc.grade})'),
                _InvRow(isUr ? 'تعداد × ریٹ' : 'Boxes × Rate',
                    '${auc.boxes} × ${formatRs(auc.rate)}'),
                const Divider(height: 20),
                _InvRow(isUr ? 'کل رقم' : 'Gross Total', formatRs(gross)),
                _InvRow(
                  isUr ? 'کمیشن' : 'Commission',
                  '-${formatRs(auc.commission)}',
                  valueColor: const Color(0xFFC2410C),
                ),
                _InvRow(
                  isUr ? 'مارکیٹ فیس' : 'Market Fee',
                  '-${formatRs(marketFee)}',
                  valueColor: const Color(0xFF6B7280),
                ),
                const Divider(height: 20),
                _InvRow(
                  isUr ? 'خالص قابل ادا' : 'Net Payable',
                  formatRs(netPayable),
                  bold: true,
                  valueColor: const Color(0xFF0E7C3A),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final text =
                    '${widget.settings.companyName}\nInvoice: ${auc.id} (${auc.date})\nFarmer: ${auc.farmerName}\nBuyer: ${auc.buyerName}\nItem: ${auc.fruit} ${auc.grade} (${auc.boxes} x Rs ${auc.rate})\nGross: ${formatRs(gross)}\nCommission: -${formatRs(auc.commission)}\nMarket Fee: -${formatRs(marketFee)}\nNet Payable: ${formatRs(netPayable)}';
                await Clipboard.setData(ClipboardData(text: text));
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isUr
                          ? 'انوائس کاپی ہو گئی'
                          : 'Invoice copied to clipboard',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.copy_rounded, size: 18),
              label: Text(isUr ? 'انوائس کاپی کریں' : 'Copy Invoice Text'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E7C3A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  const _InvRow(this.label, this.value, {this.bold = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280))),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: bold ? 16 : 13.5,
                fontWeight: bold ? FontWeight.bold : FontWeight.w600,
                color: valueColor ?? const Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 6. CASH BOOK SCREEN
class CashBookScreen extends StatefulWidget {
  final List<MandiTransaction> transactions;

  const CashBookScreen({super.key, required this.transactions});

  @override
  State<CashBookScreen> createState() => _CashBookScreenState();
}

class _CashBookScreenState extends State<CashBookScreen> {
  String _filter = 'all'; // all, credit, debit

  @override
  Widget build(BuildContext context) {
    final isUr = AppLang.isUrdu(context);
    final totalIn = widget.transactions
        .where((t) => !t.isDebit)
        .fold<int>(0, (s, t) => s + t.amount);
    final totalOut = widget.transactions
        .where((t) => t.isDebit)
        .fold<int>(0, (s, t) => s + t.amount);

    final filtered = widget.transactions.where((t) {
      if (_filter == 'credit') return !t.isDebit;
      if (_filter == 'debit') return t.isDebit;
      return true;
    }).toList();

    return _ToolScaffold(
      titleEn: 'Cash Book',
      titleUr: 'نقد کتاب',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isUr ? 'کل آمدن' : 'Cash In',
                          style: const TextStyle(
                              fontSize: 11.5, color: Color(0xFF0E7C3A))),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          formatRs(totalIn),
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0E7C3A)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF1F2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(isUr ? 'کل خرچ' : 'Cash Out',
                          style: const TextStyle(
                              fontSize: 11.5, color: Color(0xFFDC2626))),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          formatRs(totalOut),
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFDC2626)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ChipBtn(
                label: isUr ? 'سب' : 'All',
                selected: _filter == 'all',
                onTap: () => setState(() => _filter = 'all'),
              ),
              _ChipBtn(
                label: isUr ? 'آمدن (+)' : 'Credits (+)',
                selected: _filter == 'credit',
                onTap: () => setState(() => _filter = 'credit'),
              ),
              _ChipBtn(
                label: isUr ? 'خرچ (-)' : 'Debits (-)',
                selected: _filter == 'debit',
                onTap: () => setState(() => _filter = 'debit'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...filtered.map((t) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      t.isDebit
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      color: t.isDebit
                          ? const Color(0xFFDC2626)
                          : const Color(0xFF0E7C3A),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14)),
                          Text(t.subtitle,
                              style: const TextStyle(
                                  fontSize: 12, color: Color(0xFF6B7280))),
                        ],
                      ),
                    ),
                    Text(
                      '${t.isDebit ? '-' : '+'}${formatRs(t.amount)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: t.isDebit
                            ? const Color(0xFFDC2626)
                            : const Color(0xFF0E7C3A),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _ChipBtn extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ChipBtn({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0E7C3A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? const Color(0xFF0E7C3A)
                : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF4B5563),
          ),
        ),
      ),
    );
  }
}


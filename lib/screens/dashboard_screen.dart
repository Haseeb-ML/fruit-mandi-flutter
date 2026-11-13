import 'package:flutter/material.dart';
import '../models/mandi_models.dart';

class DashboardScreen extends StatefulWidget {
  final List<AuctionEntry> auctions;
  final List<ArrivalEntry> arrivals;
  final List<Buyer> buyers;
  final List<MandiTransaction> transactions;
  final int totalExpenses;
  final ValueChanged<int> onNavigateTab;
  final ValueChanged<String> onOpenTool;

  const DashboardScreen({
    super.key,
    required this.auctions,
    required this.arrivals,
    required this.buyers,
    required this.transactions,
    required this.totalExpenses,
    required this.onNavigateTab,
    required this.onOpenTool,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedDayIdx = 5; // Sat
  String _selectedFruit = 'Mango';

  @override
  Widget build(BuildContext context) {
    final extraSales = widget.auctions
        .skip(3)
        .fold<int>(0, (s, a) => s + a.boxes * a.rate);
    final extraComm = widget.auctions
        .skip(3)
        .fold<int>(0, (s, a) => s + a.commission);
    final extraBoxes =
        widget.arrivals.skip(4).fold<int>(0, (s, a) => s + a.boxes);
    final extraLots = (widget.arrivals.length - 4).clamp(0, 999);

    final todaySale = 254000 + extraSales;
    final todayCommission = 15240 + extraComm;
    final cashInHand =
        (87500 + extraComm - (widget.totalExpenses - 8400)).clamp(0, 99999999);
    final totalPending =
        widget.buyers.fold<int>(0, (s, b) => s + b.outstanding);
    final pendingParties =
        widget.buyers.where((b) => b.outstanding > 0).length;

    final kpis = [
      _KpiData(
        label: "Today's Sale",
        urdu: 'آج کی فروخت',
        value: formatRs(todaySale),
        hint: '+12%',
        hintColor: const Color(0xFF0E7C3A),
        icon: Icons.trending_up_rounded,
        iconBg: const Color(0xFFECFDF5),
        iconColor: const Color(0xFF0E7C3A),
        onTap: () => widget.onNavigateTab(4),
      ),
      _KpiData(
        label: "Today's Commission",
        urdu: 'آج کا کمیشن',
        value: formatRs(todayCommission),
        hint: '+8%',
        hintColor: const Color(0xFFDC2626),
        icon: Icons.monetization_on_outlined,
        iconBg: const Color(0xFFFFF7ED),
        iconColor: const Color(0xFFC2410C),
        onTap: () => widget.onNavigateTab(4),
      ),
      _KpiData(
        label: 'Cash in Hand',
        urdu: 'نقد رقم',
        value: formatRs(cashInHand),
        hint: '-Rs5k',
        hintColor: const Color(0xFF1D4ED8),
        icon: Icons.account_balance_wallet_outlined,
        iconBg: const Color(0xFFEFF6FF),
        iconColor: const Color(0xFF1D4ED8),
        onTap: () => widget.onOpenTool('cashbook'),
      ),
      _KpiData(
        label: 'Pending Payments',
        urdu: 'باقی ادائیگیاں',
        value: formatRs(totalPending > 300000 ? totalPending : 123000),
        hint: '$pendingParties parties',
        hintColor: const Color(0xFFBE123C),
        icon: Icons.access_time_rounded,
        iconBg: const Color(0xFFFFF1F2),
        iconColor: const Color(0xFFBE123C),
        onTap: () => widget.onNavigateTab(2),
      ),
      _KpiData(
        label: "Today's Arrivals",
        urdu: 'آج کی آمد',
        value: '${24 + extraLots} Lots',
        hint: '${formatIndianNumber(1840 + extraBoxes)} Boxes',
        hintColor: const Color(0xFF7E22CE),
        icon: Icons.inventory_2_outlined,
        iconBg: const Color(0xFFFAF5FF),
        iconColor: const Color(0xFF7E22CE),
        onTap: () => widget.onNavigateTab(3),
      ),
      _KpiData(
        label: "Today's Expenses",
        urdu: 'آج کے اخراجات',
        value: formatRs(widget.totalExpenses),
        hint: 'Labour+Transport',
        hintColor: const Color(0xFF0E7C3A),
        icon: Icons.receipt_long_outlined,
        iconBg: const Color(0xFFF0FDFA),
        iconColor: const Color(0xFF0F766E),
        onTap: () => widget.onOpenTool('expenses'),
      ),
    ];

    final activeDay = initialWeeklySales[_selectedDayIdx];
    final fruitBars = [
      ('Mango', 340),
      ('Apple', 245),
      ('Banana', 190),
      ('Citrus', 150),
    ];

    final quickItems = [
      ('Farmers', 'کاشتکار', Icons.person_outline, const Color(0xFFECFDF5), const Color(0xFF0E7C3A), () => widget.onNavigateTab(1)),
      ('Buyers', 'خریدار', Icons.groups_outlined, const Color(0xFFEFF6FF), const Color(0xFF2563EB), () => widget.onNavigateTab(2)),
      ('Arrival', 'آمد', Icons.inbox_outlined, const Color(0xFFFAF5FF), const Color(0xFF9333EA), () => widget.onNavigateTab(3)),
      ('Auction', 'نیلامی', Icons.bar_chart_rounded, const Color(0xFFFFF7ED), const Color(0xFFEA580C), () => widget.onNavigateTab(4)),
      ('Payment', 'ادائیگی', Icons.payments_outlined, const Color(0xFFF0FDFA), const Color(0xFF0D9488), () => widget.onOpenTool('payment')),
      ('Ledger', 'کھاتہ', Icons.menu_book_outlined, const Color(0xFFEEF2FF), const Color(0xFF4F46E5), () => widget.onOpenTool('ledger')),
      ('Expenses', 'اخراجات', Icons.attach_money_rounded, const Color(0xFFFFF1F2), const Color(0xFFE11D48), () => widget.onOpenTool('expenses')),
      ('Reports', 'رپورٹ', Icons.assessment_outlined, const Color(0xFFFDF2F8), const Color(0xFFDB2777), () => widget.onOpenTool('reports')),
      ('Invoice', 'انوائس', Icons.description_outlined, const Color(0xFFFEFCE8), const Color(0xFFCA8A04), () => widget.onOpenTool('invoice')),
      ('Cash Book', 'نقد کتاب', Icons.credit_card_outlined, const Color(0xFFECFEFF), const Color(0xFF0891B2), () => widget.onOpenTool('cashbook')),
    ];

    return ListView(
      key: const ValueKey('dashboard_list'),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        // 6 KPI Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: kpis.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 198,
          ),
          itemBuilder: (_, idx) {
            final k = kpis[idx];
            return InkWell(
              onTap: k.onTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: k.iconBg,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(k.icon, color: k.iconColor, size: 20),
                    ),
                    const Spacer(),
                    Text(
                      k.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      k.urdu,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(height: 2),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        k.value,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      k.hint,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: k.hintColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),

        // Weekly Sales Card
        _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly Sales',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        Text(
                          'ہفتہ وار فروخت',
                          style: TextStyle(
                              fontSize: 11.5, color: Color(0xFF9CA3AF)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'This Week',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0E7C3A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 160,
                child: Row(
                  children: [
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('260k', style: TextStyle(fontSize: 10.5, color: Color(0xFF9CA3AF))),
                        Text('195k', style: TextStyle(fontSize: 10.5, color: Color(0xFF9CA3AF))),
                        Text('130k', style: TextStyle(fontSize: 10.5, color: Color(0xFF9CA3AF))),
                        Text('65k', style: TextStyle(fontSize: 10.5, color: Color(0xFF9CA3AF))),
                        Text('0k', style: TextStyle(fontSize: 10.5, color: Color(0xFF9CA3AF))),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          void selectAtDx(double dx) {
                            final width = constraints.maxWidth;
                            if (width <= 0) return;
                            final idx = ((dx / width) *
                                    (initialWeeklySales.length - 1))
                                .round()
                                .clamp(0, initialWeeklySales.length - 1);
                            if (idx != _selectedDayIdx) {
                              setState(() => _selectedDayIdx = idx);
                            }
                          }

                          return GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTapDown: (d) => selectAtDx(d.localPosition.dx),
                            onHorizontalDragUpdate: (d) =>
                                selectAtDx(d.localPosition.dx),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: _WeeklySalesPainter(
                                      data: initialWeeklySales,
                                      selectedIndex: _selectedDayIdx,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  left: _selectedDayIdx >= 4 ? 12 : null,
                                  right: _selectedDayIdx < 4 ? 12 : null,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.96),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: const Color(0xFFE5E7EB),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.06),
                                          blurRadius: 10,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          activeDay.day,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Commission: ${formatRs(activeDay.commission)}',
                                          style: const TextStyle(
                                            fontSize: 11.5,
                                            color: Color(0xFFD97706),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          'Sales: ${formatRs(activeDay.sales)}',
                                          style: const TextStyle(
                                            fontSize: 11.5,
                                            color: Color(0xFF166534),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 34),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(initialWeeklySales.length, (i) {
                    final isSelected = i == _selectedDayIdx;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDayIdx = i),
                      child: Text(
                        initialWeeklySales[i].day,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? const Color(0xFF0E7C3A)
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Top Fruits Card
        _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Top Fruits',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const Text(
                'سب سے زیادہ فروخت',
                style: TextStyle(fontSize: 11.5, color: Color(0xFF9CA3AF)),
              ),
              const SizedBox(height: 14),
              ...fruitBars.map((item) {
                final (name, boxes) = item;
                final selected = _selectedFruit == name;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedFruit = name),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 52,
                          child: Text(
                            name,
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: LayoutBuilder(
                            builder: (_, c) {
                              final w = c.maxWidth * (boxes / 340);
                              return Stack(
                                alignment: Alignment.centerLeft,
                                children: [
                                  Container(
                                    height: 28,
                                    width: w,
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? const Color(0xFF15803D)
                                          : const Color(0xFF228B22),
                                      borderRadius: const BorderRadius.horizontal(
                                        right: Radius.circular(6),
                                      ),
                                    ),
                                  ),
                                  if (selected)
                                    Positioned(
                                      right: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withValues(alpha: 0.08),
                                              blurRadius: 6,
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          'Boxes : $boxes',
                                          style: const TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF15803D),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Quick Menu
        _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Quick Menu',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const Text(
                'فوری رسائی',
                style: TextStyle(fontSize: 11.5, color: Color(0xFF9CA3AF)),
              ),
              const SizedBox(height: 14),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quickItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 14,
                  mainAxisExtent: 98,
                ),
                itemBuilder: (_, idx) {
                  final (label, urdu, icon, bg, fg, onTap) = quickItems[idx];
                  return GestureDetector(
                    onTap: onTap,
                    child: Column(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(icon, color: fg, size: 21),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        Text(
                          urdu,
                          style: const TextStyle(
                            fontSize: 9.5,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Recent Transactions
        _CardShell(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent Transactions',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        Text(
                          'حالیہ لین دین',
                          style: TextStyle(
                              fontSize: 11.5, color: Color(0xFF9CA3AF)),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () => widget.onOpenTool('cashbook'),
                    child: const Text(
                      'View All →',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0E7C3A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...widget.transactions.take(5).map((tx) {
                final iconBg = tx.isDebit
                    ? const Color(0xFFFFEBEE)
                    : tx.category == 'payment'
                        ? const Color(0xFFEFF6FF)
                        : const Color(0xFFECFDF5);
                final iconColor = tx.isDebit
                    ? const Color(0xFFE53935)
                    : tx.category == 'payment'
                        ? const Color(0xFF2563EB)
                        : const Color(0xFF0E7C3A);
                final icon = tx.isDebit
                    ? Icons.remove
                    : tx.category == 'payment'
                        ? Icons.account_balance_wallet_outlined
                        : Icons.bar_chart_rounded;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: iconBg,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(icon, color: iconColor, size: 19),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                              ),
                            ),
                            Text(
                              tx.subtitle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${tx.isDebit ? '' : '+'}${formatRs(tx.amount)}',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.bold,
                              color: tx.isDebit
                                  ? const Color(0xFFDC2626)
                                  : const Color(0xFF0E7C3A),
                            ),
                          ),
                          Text(
                            tx.id,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardShell extends StatelessWidget {
  final Widget child;
  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _KpiData {
  final String label;
  final String urdu;
  final String value;
  final String hint;
  final Color hintColor;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final VoidCallback onTap;

  _KpiData({
    required this.label,
    required this.urdu,
    required this.value,
    required this.hint,
    required this.hintColor,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.onTap,
  });
}

class _WeeklySalesPainter extends CustomPainter {
  final List<WeeklyDaySale> data;
  final int selectedIndex;

  _WeeklySalesPainter({required this.data, required this.selectedIndex});

  @override
  void paint(Canvas canvas, Size size) {
    const maxY = 260000.0;
    final gridPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final pts = <Offset>[];
    final commPts = <Offset>[];
    for (int i = 0; i < data.length; i++) {
      final x = size.width * (i / (data.length - 1));
      final y = size.height * (1 - (data[i].sales / maxY).clamp(0.0, 1.0));
      final cy =
          size.height * (1 - (data[i].commission / maxY).clamp(0.0, 1.0));
      pts.add(Offset(x, y));
      commPts.add(Offset(x, cy));
    }

    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    final commPath = Path()..moveTo(commPts.first.dx, commPts.first.dy);
    for (int i = 1; i < pts.length; i++) {
      final cx = (pts[i - 1].dx + pts[i].dx) / 2;
      path.cubicTo(
        cx,
        pts[i - 1].dy,
        cx,
        pts[i].dy,
        pts[i].dx,
        pts[i].dy,
      );
      commPath.cubicTo(
        cx,
        commPts[i - 1].dy,
        cx,
        commPts[i].dy,
        commPts[i].dx,
        commPts[i].dy,
      );
    }

    final areaPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final areaPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF166534).withValues(alpha: 0.22),
          const Color(0xFF166534).withValues(alpha: 0.01),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(areaPath, areaPaint);
    canvas.drawPath(
      path,
      Paint()
        ..color = const Color(0xFF166534)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawPath(
      commPath,
      Paint()
        ..color = const Color(0xFFD97706)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    final sel = pts[selectedIndex];
    final selComm = commPts[selectedIndex];
    canvas.drawLine(
      Offset(sel.dx, 0),
      Offset(sel.dx, size.height),
      Paint()
        ..color = const Color(0xFFD1D5DB)
        ..strokeWidth = 1,
    );
    canvas.drawCircle(sel, 5, Paint()..color = const Color(0xFF166534));
    canvas.drawCircle(
      sel,
      5,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawCircle(selComm, 4, Paint()..color = const Color(0xFFD97706));
  }

  @override
  bool shouldRepaint(covariant _WeeklySalesPainter old) =>
      old.selectedIndex != selectedIndex;
}


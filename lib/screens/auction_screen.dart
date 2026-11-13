import 'package:flutter/material.dart';
import '../models/mandi_models.dart';

class AuctionScreen extends StatelessWidget {
  final List<AuctionEntry> auctions;
  final List<Farmer> farmers;
  final List<Buyer> buyers;
  final double commissionPercent;
  final ValueChanged<AuctionEntry> onAdd;

  const AuctionScreen({
    super.key,
    required this.auctions,
    required this.farmers,
    required this.buyers,
    required this.commissionPercent,
    required this.onAdd,
  });

  void _openNewAuction(BuildContext context) {
    String fruit = 'Mango';
    String grade = 'A-Grade';
    String farmerName = farmers.isNotEmpty ? farmers.first.name : '';
    String buyerName = buyers.isNotEmpty ? buyers.first.businessName : '';
    final boxesCtrl = TextEditingController();
    final rateCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          final boxes = int.tryParse(boxesCtrl.text.trim()) ?? 0;
          final rate = int.tryParse(rateCtrl.text.trim()) ?? 0;
          final gross = boxes * rate;
          final comm = ((gross * commissionPercent) / 100).round();
          final net = (gross - comm).clamp(0, 999999999);

          return Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              20,
              20,
              MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'New Auction / Sale — نئی نیلامی',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: farmers.any((f) => f.name == farmerName)
                        ? farmerName
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Farmer  کاشتکار',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    items: farmers
                        .map((f) => DropdownMenuItem(
                              value: f.name,
                              child: Text(f.name),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setModalState(() => farmerName = v);
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: buyers.any((b) => b.businessName == buyerName)
                        ? buyerName
                        : null,
                    decoration: InputDecoration(
                      labelText: 'Buyer  خریدار',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    items: buyers
                        .map((b) => DropdownMenuItem(
                              value: b.businessName,
                              child: Text(b.businessName),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) setModalState(() => buyerName = v);
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: fruit,
                          decoration: InputDecoration(
                            labelText: 'Fruit  پھل',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          items: const [
                            'Mango',
                            'Banana',
                            'Citrus',
                            'Apple',
                            'Guava',
                          ]
                              .map((f) =>
                                  DropdownMenuItem(value: f, child: Text(f)))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) setModalState(() => fruit = v);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: grade,
                          decoration: InputDecoration(
                            labelText: 'Grade',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          items: const ['A-Grade', 'B-Grade']
                              .map((g) =>
                                  DropdownMenuItem(value: g, child: Text(g)))
                              .toList(),
                          onChanged: (v) {
                            if (v != null) setModalState(() => grade = v);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: boxesCtrl,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setModalState(() {}),
                          decoration: InputDecoration(
                            labelText: 'Boxes',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: rateCtrl,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setModalState(() {}),
                          decoration: InputDecoration(
                            labelText: 'Rate (Rs)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Commission ($commissionPercent%): ${formatRs(comm)}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFC2410C),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Net: ${formatRs(net)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0E7C3A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (boxes <= 0 || rate <= 0) return;
                        final code =
                            (140 + auctions.length + 1).toString().padLeft(4, '0');
                        onAdd(
                          AuctionEntry(
                            id: 'AUC-$code',
                            code: code,
                            date: DateTime.now()
                                .toIso8601String()
                                .substring(0, 10),
                            fruit: fruit,
                            grade: grade,
                            farmerName: farmerName,
                            buyerName: buyerName,
                            boxes: boxes,
                            rate: rate,
                            commission: comm,
                            net: net,
                          ),
                        );
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E7C3A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Save Auction — محفوظ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Auction / Sale',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Text(
                    '${auctions.length} entries — نیلامی',
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => _openNewAuction(context),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Auction'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E7C3A),
                foregroundColor: Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...auctions.map((auc) {
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
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
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        auc.code,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF9A3412),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            auc.id,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            auc.date,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        auc.fruit,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0E7C3A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        auc.grade,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Farmer / کاشتکار',
                              style: TextStyle(
                                  fontSize: 11, color: Color(0xFF9CA3AF))),
                          const SizedBox(height: 2),
                          Text(auc.farmerName,
                              style: const TextStyle(
                                  fontSize: 13.5, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Buyer / خریدار',
                              style: TextStyle(
                                  fontSize: 11, color: Color(0xFF9CA3AF))),
                          const SizedBox(height: 2),
                          Text(auc.buyerName,
                              style: const TextStyle(
                                  fontSize: 13.5, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24, color: Color(0xFFF3F4F6)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _MetricCol('Boxes', '${auc.boxes}', const Color(0xFF111827)),
                    _MetricCol(
                      'Rate / ریٹ',
                      'Rs${formatIndianNumber(auc.rate)}',
                      const Color(0xFF111827),
                    ),
                    _MetricCol(
                      'Commission',
                      'Rs${formatIndianNumber(auc.commission)}',
                      const Color(0xFFC2410C),
                    ),
                    _MetricCol(
                      'Net / خالص',
                      'Rs${formatIndianNumber(auc.net)}',
                      const Color(0xFF0E7C3A),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _MetricCol extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricCol(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF))),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}


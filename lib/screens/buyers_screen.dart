import 'package:flutter/material.dart';
import '../models/mandi_models.dart';
import '../widgets/confirm_delete_dialog.dart';

class BuyersScreen extends StatefulWidget {
  final List<Buyer> buyers;
  final ValueChanged<Buyer> onAdd;
  final ValueChanged<Buyer> onUpdate;
  final ValueChanged<String> onDelete;

  const BuyersScreen({
    super.key,
    required this.buyers,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<BuyersScreen> createState() => _BuyersScreenState();
}

class _BuyersScreenState extends State<BuyersScreen> {
  String _query = '';

  void _openBuyerModal({Buyer? existing}) {
    final shopCtrl = TextEditingController(text: existing?.businessName ?? '');
    final ownerCtrl = TextEditingController(text: existing?.contactName ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '');
    final marketCtrl = TextEditingController(text: existing?.mandi ?? '');
    final limitCtrl = TextEditingController(
      text: (existing?.creditLimit ?? 50000).toString(),
    );

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                existing == null ? 'Add Buyer — نیا خریدار' : 'Edit Buyer — ترمیم',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _BuyerField('Shop Name  دکان کا نام', shopCtrl, 'Khan Fruit Centre'),
              _BuyerField('Owner  مالک', ownerCtrl, 'Asif Khan'),
              _BuyerField('Phone  فون', phoneCtrl, '0300-1122334',
                  keyboard: TextInputType.phone),
              _BuyerField('Market  منڈی', marketCtrl, 'Lahore Mandi'),
              _BuyerField('Credit Limit  کریڈٹ حد', limitCtrl, '50000',
                  keyboard: TextInputType.number),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (shopCtrl.text.trim().isEmpty) return;
                        final item = Buyer(
                          id: existing?.id ??
                              'b-${DateTime.now().millisecondsSinceEpoch}',
                          businessName: shopCtrl.text.trim(),
                          contactName: ownerCtrl.text.trim().isEmpty
                              ? 'Owner'
                              : ownerCtrl.text.trim(),
                          phone: phoneCtrl.text.trim().isEmpty
                              ? '0300-0000000'
                              : phoneCtrl.text.trim(),
                          mandi: marketCtrl.text.trim().isEmpty
                              ? 'Lahore Mandi'
                              : marketCtrl.text.trim(),
                          outstanding: existing?.outstanding ?? 0,
                          creditLimit:
                              (int.tryParse(limitCtrl.text.trim()) ?? 50000)
                                  .clamp(1000, 99999999),
                        );
                        if (existing == null) {
                          widget.onAdd(item);
                        } else {
                          widget.onUpdate(item);
                        }
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E7C3A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Save — محفوظ',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.buyers
        .where((b) =>
            b.businessName.toLowerCase().contains(_query.toLowerCase()) ||
            b.contactName.toLowerCase().contains(_query.toLowerCase()) ||
            b.mandi.toLowerCase().contains(_query.toLowerCase()))
        .toList();

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
                    'Buyers',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  Text(
                    '${widget.buyers.length} total — خریدار',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => _openBuyerModal(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Buyer'),
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
        TextField(
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: Color(0xFF9CA3AF)),
            hintText: 'Search buyers — خریدار تلاش کریں',
            hintStyle: const TextStyle(fontSize: 13.5, color: Color(0xFF9CA3AF)),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
        ),
        const SizedBox(height: 14),
        ...filtered.map((b) {
          final ratio =
              (b.outstanding / b.creditLimit.clamp(1, 99999999)).clamp(0.0, 1.0);
          final barColor = ratio >= 0.95
              ? const Color(0xFFE11D48)
              : ratio >= 0.75
                  ? const Color(0xFFD97706)
                  : const Color(0xFF16A34A);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFFDBEAFE),
                      child: Text(
                        b.businessName[0].toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF1D4ED8),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            b.businessName,
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF111827),
                            ),
                          ),
                          Text(
                            b.contactName,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _openBuyerModal(existing: b),
                      icon: const Icon(Icons.edit_outlined,
                          size: 19, color: Color(0xFF2563EB)),
                    ),
                    IconButton(
                      onPressed: () async {
                        final ok = await showConfirmDeleteDialog(
                          context: context,
                          title: 'Delete Buyer?',
                          urduMessage: 'خریدار حذف کریں؟',
                          isWarning: true,
                        );
                        if (ok) widget.onDelete(b.id);
                      },
                      icon: const Icon(Icons.delete_outline,
                          size: 19, color: Color(0xFFE53935)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined,
                        size: 15, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 8),
                    Text(b.phone,
                        style: const TextStyle(
                            fontSize: 12.5, color: Color(0xFF4B5563))),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 15, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 8),
                    Text(b.mandi,
                        style: const TextStyle(
                            fontSize: 12.5, color: Color(0xFF4B5563))),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Flexible(
                      child: Text(
                        'Outstanding / کریڈٹ',
                        style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        '${formatRs(b.outstanding)} / ${formatIndianNumber(b.creditLimit)}',
                        textAlign: TextAlign.end,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: ratio,
                    minHeight: 7,
                    backgroundColor: const Color(0xFFF3F4F6),
                    color: barColor,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _BuyerField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboard;

  const _BuyerField(this.label, this.controller, this.hint, {this.keyboard});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboard,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


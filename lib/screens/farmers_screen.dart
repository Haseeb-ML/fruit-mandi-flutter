import 'package:flutter/material.dart';
import '../models/mandi_models.dart';
import '../widgets/confirm_delete_dialog.dart';

class FarmersScreen extends StatefulWidget {
  final List<Farmer> farmers;
  final ValueChanged<Farmer> onAdd;
  final ValueChanged<Farmer> onUpdate;
  final ValueChanged<String> onDelete;

  const FarmersScreen({
    super.key,
    required this.farmers,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<FarmersScreen> createState() => _FarmersScreenState();
}

class _FarmersScreenState extends State<FarmersScreen> {
  String _query = '';

  void _openFarmerModal({Farmer? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '');
    final villageCtrl = TextEditingController(text: existing?.village ?? '');
    final addressCtrl = TextEditingController(text: existing?.address ?? '');
    final cnicCtrl = TextEditingController(text: existing?.cnic ?? '');
    String fruit = existing?.fruit ?? 'Mango';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          existing == null ? 'Add Farmer' : 'Edit Farmer',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          existing == null ? 'نیا کاشتکار' : 'کاشتکار ترمیم',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(ctx),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _Field('Name  نام', nameCtrl, 'Muhammad Ali Khan'),
                _Field('Mobile  موبائل', phoneCtrl, '0301-2345678',
                    keyboard: TextInputType.phone),
                _Field('Village  گاؤں', villageCtrl, 'Multan'),
                _Field('Address  پتہ', addressCtrl, 'Chowk Kumharan, Multan'),
                _Field('CNIC (Optional)  شناختی کارڈ', cnicCtrl,
                    '36302-1234567-1'),
                const Text(
                  'Fruit Type  پھل کی قسم',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: fruit,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                  ),
                  items: const [
                    'Mango',
                    'Apple',
                    'Banana',
                    'Citrus',
                    'Grapes',
                    'Guava',
                    'Pomegranate',
                    'Other',
                  ]
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setModalState(() => fruit = v);
                  },
                ),
                const SizedBox(height: 18),
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
                          if (nameCtrl.text.trim().isEmpty ||
                              villageCtrl.text.trim().isEmpty) {
                            return;
                          }
                          final item = Farmer(
                            id: existing?.id ??
                                'f-${DateTime.now().millisecondsSinceEpoch}',
                            name: nameCtrl.text.trim(),
                            phone: phoneCtrl.text.trim().isEmpty
                                ? '0300-0000000'
                                : phoneCtrl.text.trim(),
                            village: villageCtrl.text.trim(),
                            address: addressCtrl.text.trim(),
                            cnic: cnicCtrl.text.trim(),
                            fruit: fruit,
                            balance: existing?.balance ?? 0,
                            balanceType: existing?.balanceType ?? 'Settled',
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.farmers
        .where((f) =>
            f.name.toLowerCase().contains(_query.toLowerCase()) ||
            f.village.toLowerCase().contains(_query.toLowerCase()) ||
            f.fruit.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Farmers',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                Text(
                  '${widget.farmers.length} total — کاشتکار',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => _openFarmerModal(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Farmer'),
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
            hintText: 'Search farmers — کاشتکار تلاش کریں',
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
        Container(
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
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor:
                  WidgetStateProperty.all(const Color(0xFFF9FAFB)),
              columnSpacing: 20,
              dataRowMaxHeight: 68,
              columns: const [
                DataColumn(
                  label: Text('NAME / نام',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280))),
                ),
                DataColumn(
                  label: Text('MOBILE / موبائل',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280))),
                ),
                DataColumn(
                  label: Text('VILLAGE / گاؤں',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280))),
                ),
                DataColumn(
                  label: Text('FRUIT / پھل',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280))),
                ),
                DataColumn(
                  label: Text('BALANCE / بیلنس',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280))),
                ),
                DataColumn(
                  label: Text('ACTIONS',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280))),
                ),
              ],
              rows: filtered.map((f) {
                return DataRow(
                  cells: [
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 17,
                            backgroundColor: const Color(0xFFECFDF5),
                            child: Text(
                              f.name.isNotEmpty
                                  ? f.name[0].toUpperCase()
                                  : 'F',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0E7C3A),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                f.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF111827),
                                ),
                              ),
                              if (f.address.isNotEmpty)
                                Text(
                                  f.address,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    DataCell(Text(f.phone,
                        style: const TextStyle(color: Color(0xFF4B5563)))),
                    DataCell(Text(f.village,
                        style: const TextStyle(color: Color(0xFF374151)))),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          f.fruit,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0E7C3A),
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      f.balance > 0
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  formatRs(f.balance),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: f.balanceType == 'Receivable'
                                        ? const Color(0xFFBE123C)
                                        : const Color(0xFF0E7C3A),
                                  ),
                                ),
                                Text(
                                  f.balanceType,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                ),
                              ],
                            )
                          : const Text('—',
                              style: TextStyle(color: Color(0xFF9CA3AF))),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _openFarmerModal(existing: f),
                            icon: const Icon(Icons.edit_outlined,
                                size: 19, color: Color(0xFF2563EB)),
                          ),
                          IconButton(
                            onPressed: () async {
                              final ok = await showConfirmDeleteDialog(
                                context: context,
                                title: 'Delete Farmer?',
                                urduMessage:
                                    'کاشتکار حذف کریں؟ یہ عمل واپس نہیں ہو سکتا۔',
                              );
                              if (ok) widget.onDelete(f.id);
                            },
                            icon: const Icon(Icons.delete_outline,
                                size: 19, color: Color(0xFFE53935)),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboard;

  const _Field(this.label, this.controller, this.hint, {this.keyboard});

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


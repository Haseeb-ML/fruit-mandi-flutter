import 'package:flutter/material.dart';
import '../models/mandi_models.dart';
import '../widgets/confirm_delete_dialog.dart';

class ArrivalScreen extends StatefulWidget {
  final List<ArrivalEntry> arrivals;
  final List<Farmer> farmers;
  final ValueChanged<ArrivalEntry> onAdd;
  final ValueChanged<ArrivalEntry> onUpdate;
  final ValueChanged<String> onDelete;

  const ArrivalScreen({
    super.key,
    required this.arrivals,
    required this.farmers,
    required this.onAdd,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<ArrivalScreen> createState() => _ArrivalScreenState();
}

class _ArrivalScreenState extends State<ArrivalScreen> {
  String _query = '';

  void _openModal({ArrivalEntry? existing}) {
    final dateCtrl = TextEditingController(
      text: existing?.date ?? DateTime.now().toIso8601String().substring(0, 10),
    );
    String farmerName = existing?.farmerName ??
        (widget.farmers.isNotEmpty ? widget.farmers.first.name : '');
    String fruit = existing?.fruit ?? 'Mango';
    String grade = existing?.grade ?? 'A-Grade';
    final boxesCtrl =
        TextEditingController(text: existing?.boxes.toString() ?? '');
    final weightCtrl =
        TextEditingController(text: existing?.weightKg.toString() ?? '');

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
                Text(
                  existing == null
                      ? 'New Fruit Arrival — نیا پھل آمد'
                      : 'Edit Fruit Arrival',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Date  تاریخ',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextField(
                  controller: dateCtrl,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Farmer  کاشتکار',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: widget.farmers.any((f) => f.name == farmerName)
                      ? farmerName
                      : null,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  items: widget.farmers
                      .map((f) => DropdownMenuItem(
                            value: f.name,
                            child: Text('${f.name} (${f.village})'),
                          ))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setModalState(() => farmerName = v);
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
                          'Citrus',
                          'Banana',
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
                          labelText: 'Grade  درجہ',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        items: const ['A-Grade', 'B-Grade', 'C-Grade']
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
                        onChanged: (val) {
                          final b = int.tryParse(val) ?? 0;
                          if (b > 0) weightCtrl.text = (b * 20).toString();
                        },
                        decoration: InputDecoration(
                          labelText: 'Boxes  ڈبے',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: weightCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Weight (kg)  وزن',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          final boxes = int.tryParse(boxesCtrl.text.trim()) ?? 0;
                          if (boxes <= 0 || farmerName.isEmpty) return;
                          final weight =
                              int.tryParse(weightCtrl.text.trim()) ??
                                  boxes * 20;
                          final entry = ArrivalEntry(
                            id: existing?.id ??
                                'arr-${DateTime.now().millisecondsSinceEpoch}',
                            date: dateCtrl.text.trim(),
                            farmerName: farmerName,
                            fruit: fruit,
                            grade: grade,
                            boxes: boxes,
                            weightKg: weight,
                          );
                          if (existing == null) {
                            widget.onAdd(entry);
                          } else {
                            widget.onUpdate(entry);
                          }
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
                        child: const Text('Save — محفوظ'),
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
    final filtered = widget.arrivals
        .where((a) =>
            a.farmerName.toLowerCase().contains(_query.toLowerCase()) ||
            a.fruit.toLowerCase().contains(_query.toLowerCase()) ||
            a.date.contains(_query))
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
                  'Fruit Arrival',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                Text(
                  '${widget.arrivals.length} entries — پھل آمد',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () => _openModal(),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Arrival'),
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
            hintText: 'Search by farmer, fruit, date — تلاش کریں',
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
              columns: const [
                DataColumn(
                  label: Text('DATE / تاریخ',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280))),
                ),
                DataColumn(
                  label: Text('FARMER / کاشتکار',
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
                  label: Text('GRADE / درجہ',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280))),
                ),
                DataColumn(
                  label: Text('BOXES / ڈبے',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280))),
                ),
                DataColumn(
                  label: Text('WEIGHT / وزن',
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
              rows: filtered.map((a) {
                final isA = a.grade == 'A-Grade';
                return DataRow(
                  cells: [
                    DataCell(Text(a.date,
                        style: const TextStyle(color: Color(0xFF4B5563)))),
                    DataCell(Text(a.farmerName,
                        style: const TextStyle(fontWeight: FontWeight.w600))),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          a.fruit,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF0E7C3A),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isA
                              ? const Color(0xFFECFDF5)
                              : const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          a.grade,
                          style: TextStyle(
                            fontSize: 12,
                            color: isA
                                ? const Color(0xFF0E7C3A)
                                : const Color(0xFF1D4ED8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    DataCell(Text('${a.boxes}',
                        style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(Text('${a.weightKg} kg',
                        style: const TextStyle(color: Color(0xFF4B5563)))),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () => _openModal(existing: a),
                            icon: const Icon(Icons.edit_outlined,
                                size: 19, color: Color(0xFF2563EB)),
                          ),
                          IconButton(
                            onPressed: () async {
                              final ok = await showConfirmDeleteDialog(
                                context: context,
                                title: 'Delete Arrival?',
                                urduMessage: 'پھل آمد حذف کریں؟',
                              );
                              if (ok) widget.onDelete(a.id);
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


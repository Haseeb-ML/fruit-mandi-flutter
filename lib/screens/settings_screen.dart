import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_lang.dart';
import '../models/mandi_models.dart';

class SettingsScreen extends StatefulWidget {
  final MandiSettings settings;
  final ValueChanged<MandiSettings> onSave;
  final String Function() onExportJson;
  final ValueChanged<String> onImportJson;
  final VoidCallback onReset;
  final VoidCallback onLogout;

  const SettingsScreen({
    super.key,
    required this.settings,
    required this.onSave,
    required this.onExportJson,
    required this.onImportJson,
    required this.onReset,
    required this.onLogout,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final TextEditingController _companyCtrl;
  late final TextEditingController _ownerCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _licenseCtrl;
  late final TextEditingController _addressCtrl;
  late final TextEditingController _commCtrl;
  late final TextEditingController _feeCtrl;

  @override
  void initState() {
    super.initState();
    _companyCtrl = TextEditingController(text: widget.settings.companyName);
    _ownerCtrl = TextEditingController(text: widget.settings.ownerName);
    _phoneCtrl = TextEditingController(text: widget.settings.phone);
    _cityCtrl = TextEditingController(text: widget.settings.city);
    _licenseCtrl = TextEditingController(text: widget.settings.licenseNo);
    _addressCtrl = TextEditingController(text: widget.settings.address);
    _commCtrl = TextEditingController(
        text: widget.settings.defaultCommissionPercent.toString());
    _feeCtrl =
        TextEditingController(text: widget.settings.marketFeePercent.toString());
  }

  @override
  void dispose() {
    _companyCtrl.dispose();
    _ownerCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    _licenseCtrl.dispose();
    _addressCtrl.dispose();
    _commCtrl.dispose();
    _feeCtrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSave(
      MandiSettings(
        companyName: _companyCtrl.text.trim(),
        ownerName: _ownerCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        licenseNo: _licenseCtrl.text.trim(),
        address: _addressCtrl.text.trim(),
        defaultCommissionPercent:
            double.tryParse(_commCtrl.text.trim()) ?? 6.0,
        marketFeePercent: double.tryParse(_feeCtrl.text.trim()) ?? 0.5,
        language: AppLang.isUrdu(context) ? 'ur' : 'en',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLang.t(
          context,
          'Settings saved',
          'ترتیبات محفوظ ہو گئیں',
        )),
      ),
    );
  }

  void _backup() async {
    final json = widget.onExportJson();
    await Clipboard.setData(ClipboardData(text: json));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Backup JSON copied to clipboard — بیک اپ کاپی ہو گیا'),
      ),
    );
  }

  void _restore() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Restore Backup — بحالی'),
        content: TextField(
          controller: ctrl,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Paste backup JSON here...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onImportJson(ctrl.text.trim());
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E7C3A),
              foregroundColor: Colors.white,
            ),
            child: const Text('Restore'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUr = AppLang.isUrdu(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          isUr ? 'ترتیبات' : 'Settings',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        Text(
          isUr ? 'Settings' : 'ترتیبات',
          style: const TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: isUr ? 'زبان منتخب کریں' : 'Language',
          urdu: isUr ? 'Language' : 'زبان',
          children: [
            Row(
              children: [
                Expanded(
                  child: _LangOptionButton(
                    label: 'English',
                    sublabel: 'انگریزی',
                    selected: !isUr,
                    onTap: () => AppLang.set(context, 'en'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _LangOptionButton(
                    label: 'اردو',
                    sublabel: 'Urdu',
                    selected: isUr,
                    onTap: () => AppLang.set(context, 'ur'),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: isUr ? 'کمپنی معلومات' : 'Company Information',
          urdu: isUr ? 'Company Information' : 'کمپنی معلومات',
          children: [
            _SettingsField('Company Name  کمپنی کا نام', _companyCtrl),
            _SettingsField('Owner Name  مالک', _ownerCtrl),
            _SettingsField('Phone  فون', _phoneCtrl),
            _SettingsField('City  شہر', _cityCtrl),
            _SettingsField('License No  لائسنس', _licenseCtrl),
            _SettingsField('Address  پتہ', _addressCtrl),
          ],
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: 'Commission Settings',
          urdu: 'کمیشن ترتیبات',
          children: [
            Row(
              children: [
                Expanded(
                  child: _SettingsField(
                    'Default Commission %\nکمیشن',
                    _commCtrl,
                    suffix: '%',
                    keyboard: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _SettingsField(
                    'Market Fee %  مارکیٹ فیس',
                    _feeCtrl,
                    suffix: '%',
                    keyboard: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        _SectionCard(
          title: 'Data Management',
          urdu: 'ڈیٹا انتظام',
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _backup,
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: const Text('Backup — بیک اپ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEFF6FF),
                      foregroundColor: const Color(0xFF1D4ED8),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _restore,
                    icon: const Icon(Icons.upload_rounded, size: 18),
                    label: const Text('Restore — بحالی'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFF7ED),
                      foregroundColor: const Color(0xFFC2410C),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onReset,
                    icon: const Icon(Icons.refresh, size: 16),
                    label: const Text('Reset Demo'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF4B5563),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onLogout,
                    icon: const Icon(Icons.logout, size: 16),
                    label: const Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFDC2626),
                      side: const BorderSide(color: Color(0xFFFECACA)),
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            children: [
              Text(
                'Fruit Mandi Arhti System v1.0',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF1F2937),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'فروٹ منڈی آڑھتی سسٹم · Built for Pakistani Fruit Markets',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11.5, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0E7C3A),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Save Settings — ترتیبات محفوظ کریں',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String urdu;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.urdu,
    required this.children,
  });

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          Text(
            urdu,
            style: const TextStyle(fontSize: 11.5, color: Color(0xFF9CA3AF)),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _SettingsField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? suffix;
  final TextInputType? keyboard;

  const _SettingsField(
    this.label,
    this.controller, {
    this.suffix,
    this.keyboard,
  });

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
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboard,
            decoration: InputDecoration(
              suffixText: suffix,
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

class _LangOptionButton extends StatelessWidget {
  final String label;
  final String sublabel;
  final bool selected;
  final VoidCallback onTap;

  const _LangOptionButton({
    required this.label,
    required this.sublabel,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFECFDF5) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? const Color(0xFF0E7C3A)
                : const Color(0xFFE5E7EB),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              size: 18,
              color: selected
                  ? const Color(0xFF0E7C3A)
                  : const Color(0xFF9CA3AF),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: selected
                        ? const Color(0xFF0E7C3A)
                        : const Color(0xFF111827),
                  ),
                ),
                Text(
                  sublabel,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


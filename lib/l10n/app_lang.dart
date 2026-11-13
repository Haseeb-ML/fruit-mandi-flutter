import 'package:flutter/material.dart';

class AppLang extends InheritedWidget {
  final String language; // 'en' or 'ur'
  final ValueChanged<String> onChangeLanguage;

  const AppLang({
    super.key,
    required this.language,
    required this.onChangeLanguage,
    required super.child,
  });

  static AppLang? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppLang>();

  static bool isUrdu(BuildContext context) =>
      maybeOf(context)?.language == 'ur';

  static String t(BuildContext context, String en, String ur) =>
      isUrdu(context) ? ur : en;

  static void toggle(BuildContext context) {
    final scope = maybeOf(context);
    if (scope == null) return;
    scope.onChangeLanguage(scope.language == 'ur' ? 'en' : 'ur');
  }

  static void set(BuildContext context, String lang) {
    maybeOf(context)?.onChangeLanguage(lang);
  }

  @override
  bool updateShouldNotify(AppLang oldWidget) =>
      oldWidget.language != language;
}

class LanguageTogglePill extends StatelessWidget {
  const LanguageTogglePill({super.key});

  @override
  Widget build(BuildContext context) {
    final isUr = AppLang.isUrdu(context);
    return InkWell(
      key: const ValueKey('language_toggle_pill'),
      onTap: () => AppLang.toggle(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFBBF7D0)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.translate, size: 14, color: Color(0xFF0E7C3A)),
            const SizedBox(width: 4),
            Text(
              isUr ? 'اردو | EN' : 'EN | اردو',
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0E7C3A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


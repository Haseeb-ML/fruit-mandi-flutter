import 'dart:convert';
import 'package:flutter/material.dart';
import 'l10n/app_lang.dart';
import 'models/mandi_models.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/farmers_screen.dart';
import 'screens/buyers_screen.dart';
import 'screens/arrival_screen.dart';
import 'screens/auction_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/notifications_screen.dart';

void main() {
  runApp(const FruitMandiApp());
}

class FruitMandiApp extends StatelessWidget {
  const FruitMandiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al-Barkat Fruit Mandi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF0E7C3A),
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
      ),
      home: const MandiRoot(),
    );
  }
}

class MandiRoot extends StatefulWidget {
  const MandiRoot({super.key});

  @override
  State<MandiRoot> createState() => _MandiRootState();
}

class _MandiRootState extends State<MandiRoot> {
  bool _loggedIn = false;
  int _tabIndex = 0;
  bool _showNotifications = false;

  MandiSettings _settings = MandiSettings.defaults();
  List<Farmer> _farmers = initialFarmers();
  List<Buyer> _buyers = initialBuyers();
  List<ArrivalEntry> _arrivals = initialArrivals();
  List<AuctionEntry> _auctions = initialAuctions();
  List<MandiTransaction> _transactions = initialTransactions();
  List<MandiNotification> _notifications = initialNotifications();
  int _totalExpenses = 8400;

  @override
  void initState() {
    super.initState();
    _loadPersisted();
  }

  Future<void> _loadPersisted() async {
    final data = await LocalStore.load();
    if (data == null || !mounted) return;
    setState(() {
      if (data['settings'] != null) {
        _settings = MandiSettings.fromJson(data['settings']);
      }
      if (data['farmers'] is List) {
        _farmers = (data['farmers'] as List)
            .map((e) => Farmer.fromJson(e))
            .toList();
      }
      if (data['buyers'] is List) {
        _buyers =
            (data['buyers'] as List).map((e) => Buyer.fromJson(e)).toList();
      }
      if (data['arrivals'] is List) {
        _arrivals = (data['arrivals'] as List)
            .map((e) => ArrivalEntry.fromJson(e))
            .toList();
      }
      if (data['auctions'] is List) {
        _auctions = (data['auctions'] as List)
            .map((e) => AuctionEntry.fromJson(e))
            .toList();
      }
      if (data['totalExpenses'] is num) {
        _totalExpenses = (data['totalExpenses'] as num).toInt();
      }
    });
  }

  void _persist() {
    LocalStore.save({
      'settings': _settings.toJson(),
      'farmers': _farmers.map((e) => e.toJson()).toList(),
      'buyers': _buyers.map((e) => e.toJson()).toList(),
      'arrivals': _arrivals.map((e) => e.toJson()).toList(),
      'auctions': _auctions.map((e) => e.toJson()).toList(),
      'totalExpenses': _totalExpenses,
    });
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return 'AK';
    if (parts.length == 1) return parts.first.substring(0, 2).toUpperCase();
    return (parts[parts.length - 2][0] + parts.last[0]).toUpperCase();
  }

  String _todayLabel() {
    final now = DateTime.now();
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${days[now.weekday - 1]}, ${now.day.toString().padLeft(2, '0')} ${months[now.month - 1]} ${now.year}';
  }

  void _openQuickTool(String tool) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        if (tool == 'payment') {
          String buyerId = _buyers.isNotEmpty ? _buyers.first.id : '';
          final amtCtrl = TextEditingController();
          return StatefulBuilder(
            builder: (ctx, setS) => Padding(
              padding: EdgeInsets.fromLTRB(
                20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Record Payment — ادائیگی درج کریں',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    initialValue: buyerId.isEmpty ? null : buyerId,
                    decoration: InputDecoration(
                      labelText: 'Buyer  خریدار',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    items: _buyers
                        .map((b) => DropdownMenuItem(
                              value: b.id,
                              child: Text(
                                  '${b.businessName} (${formatRs(b.outstanding)})'),
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
                      labelText: 'Amount Received (Rs)',
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
                        if (amt <= 0 || buyerId.isEmpty) return;
                        setState(() {
                          final idx = _buyers.indexWhere((b) => b.id == buyerId);
                          if (idx != -1) {
                            _buyers[idx].outstanding =
                                (_buyers[idx].outstanding - amt)
                                    .clamp(0, 99999999);
                            _transactions.insert(
                              0,
                              MandiTransaction(
                                id: 'PAY-${90 + _transactions.length}',
                                title: _buyers[idx].businessName,
                                subtitle: 'Payment Received',
                                amount: amt,
                                isDebit: false,
                                category: 'payment',
                              ),
                            );
                          }
                        });
                        _persist();
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0E7C3A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text('Save Payment — محفوظ'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (tool == 'expenses') {
          final titleCtrl = TextEditingController();
          final amtCtrl = TextEditingController();
          return Padding(
            padding: EdgeInsets.fromLTRB(
              20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Add Expense — اخراجات',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 14),
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: 'Description (e.g. Labour / Transport)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amtCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Amount (Rs)',
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
                      if (titleCtrl.text.trim().isEmpty || amt <= 0) return;
                      setState(() {
                        _totalExpenses += amt;
                        _transactions.insert(
                          0,
                          MandiTransaction(
                            id: 'EXP-${35 + _transactions.length}',
                            title: titleCtrl.text.trim(),
                            subtitle: 'Daily Expense',
                            amount: amt,
                            isDebit: true,
                            category: 'expense',
                          ),
                        );
                      });
                      _persist();
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0E7C3A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Save Expense — محفوظ'),
                  ),
                ),
              ],
            ),
          );
        }

        // Ledger / Reports / Invoice / Cash Book summary sheet
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tool.toUpperCase(),
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (tool == 'ledger')
                ..._farmers.map((f) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(f.name,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(f.village),
                      trailing: Text(
                        f.balance > 0
                            ? '${formatRs(f.balance)} (${f.balanceType})'
                            : 'Settled',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: f.balanceType == 'Receivable'
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF0E7C3A),
                        ),
                      ),
                    ))
              else
                ..._transactions.take(6).map((t) => ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(t.title,
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('${t.id} · ${t.subtitle}'),
                      trailing: Text(
                        '${t.isDebit ? '-' : '+'}${formatRs(t.amount)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: t.isDebit
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF0E7C3A),
                        ),
                      ),
                    )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUr = _settings.language == 'ur';

    Widget content;
    if (!_loggedIn) {
      content = LoginScreen(onLogin: () => setState(() => _loggedIn = true));
    } else {
      final titles = isUr
          ? const [
              'ڈیش بورڈ',
              'کاشتکار',
              'خریدار',
              'پھل آمد',
              'نیلامی',
              'سیٹنگز',
            ]
          : const [
              'Dashboard',
              'Farmers',
              'Buyers',
              'Arrival',
              'Auction',
              'Settings',
            ];
      final unreadCount = _notifications.where((n) => n.unread).length;

      Widget body;
    if (_showNotifications) {
      body = NotificationsScreen(
        notifications: _notifications,
        onMarkAllRead: () => setState(() {
          for (final n in _notifications) {
            n.unread = false;
          }
        }),
        onMarkOneRead: (id) => setState(() {
          final idx = _notifications.indexWhere((n) => n.id == id);
          if (idx != -1) _notifications[idx].unread = false;
        }),
      );
    } else {
      switch (_tabIndex) {
        case 0:
          body = DashboardScreen(
            auctions: _auctions,
            arrivals: _arrivals,
            buyers: _buyers,
            transactions: _transactions,
            totalExpenses: _totalExpenses,
            onNavigateTab: (i) => setState(() {
              _showNotifications = false;
              _tabIndex = i;
            }),
            onOpenTool: _openQuickTool,
          );
          break;
        case 1:
          body = FarmersScreen(
            farmers: _farmers,
            onAdd: (f) {
              setState(() => _farmers.insert(0, f));
              _persist();
            },
            onUpdate: (f) {
              setState(() {
                final i = _farmers.indexWhere((x) => x.id == f.id);
                if (i != -1) _farmers[i] = f;
              });
              _persist();
            },
            onDelete: (id) {
              setState(() => _farmers.removeWhere((x) => x.id == id));
              _persist();
            },
          );
          break;
        case 2:
          body = BuyersScreen(
            buyers: _buyers,
            onAdd: (b) {
              setState(() => _buyers.insert(0, b));
              _persist();
            },
            onUpdate: (b) {
              setState(() {
                final i = _buyers.indexWhere((x) => x.id == b.id);
                if (i != -1) _buyers[i] = b;
              });
              _persist();
            },
            onDelete: (id) {
              setState(() => _buyers.removeWhere((x) => x.id == id));
              _persist();
            },
          );
          break;
        case 3:
          body = ArrivalScreen(
            arrivals: _arrivals,
            farmers: _farmers,
            onAdd: (a) {
              setState(() => _arrivals.insert(0, a));
              _persist();
            },
            onUpdate: (a) {
              setState(() {
                final i = _arrivals.indexWhere((x) => x.id == a.id);
                if (i != -1) _arrivals[i] = a;
              });
              _persist();
            },
            onDelete: (id) {
              setState(() => _arrivals.removeWhere((x) => x.id == id));
              _persist();
            },
          );
          break;
        case 4:
          body = AuctionScreen(
            auctions: _auctions,
            farmers: _farmers,
            buyers: _buyers,
            commissionPercent: _settings.defaultCommissionPercent,
            onAdd: (auc) {
              setState(() {
                _auctions.insert(0, auc);
                _transactions.insert(
                  0,
                  MandiTransaction(
                    id: auc.id,
                    title: '${auc.farmerName} → ${auc.buyerName}',
                    subtitle: '${auc.fruit} ${auc.grade} · ${auc.boxes} boxes',
                    amount: auc.boxes * auc.rate,
                    isDebit: false,
                    category: 'auction',
                  ),
                );
              });
              _persist();
            },
          );
          break;
        default:
          body = SettingsScreen(
            settings: _settings,
            onSave: (s) {
              setState(() => _settings = s);
              _persist();
            },
            onExportJson: () => jsonEncode({
              'settings': _settings.toJson(),
              'farmers': _farmers.map((e) => e.toJson()).toList(),
              'buyers': _buyers.map((e) => e.toJson()).toList(),
              'arrivals': _arrivals.map((e) => e.toJson()).toList(),
              'auctions': _auctions.map((e) => e.toJson()).toList(),
              'totalExpenses': _totalExpenses,
            }),
            onImportJson: (txt) {
              try {
                final d = jsonDecode(txt) as Map<String, dynamic>;
                setState(() {
                  if (d['settings'] != null) {
                    _settings = MandiSettings.fromJson(d['settings']);
                  }
                  if (d['farmers'] is List) {
                    _farmers = (d['farmers'] as List)
                        .map((e) => Farmer.fromJson(e))
                        .toList();
                  }
                  if (d['buyers'] is List) {
                    _buyers = (d['buyers'] as List)
                        .map((e) => Buyer.fromJson(e))
                        .toList();
                  }
                  if (d['arrivals'] is List) {
                    _arrivals = (d['arrivals'] as List)
                        .map((e) => ArrivalEntry.fromJson(e))
                        .toList();
                  }
                  if (d['auctions'] is List) {
                    _auctions = (d['auctions'] as List)
                        .map((e) => AuctionEntry.fromJson(e))
                        .toList();
                  }
                });
                _persist();
              } catch (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid backup JSON')),
                );
              }
            },
            onReset: () {
              setState(() {
                _settings = MandiSettings.defaults();
                _farmers = initialFarmers();
                _buyers = initialBuyers();
                _arrivals = initialArrivals();
                _auctions = initialAuctions();
                _transactions = initialTransactions();
                _notifications = initialNotifications();
                _totalExpenses = 8400;
              });
              _persist();
            },
            onLogout: () => setState(() => _loggedIn = false),
          );
      }
    }

      content = Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _showNotifications ? (isUr ? 'اطلاعات' : 'App') : titles[_tabIndex],
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),
            Text(
              _todayLabel(),
              style: const TextStyle(fontSize: 11.5, color: Color(0xFF9CA3AF)),
            ),
          ],
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: LanguageTogglePill(),
          ),
          IconButton(
            onPressed: () =>
                setState(() => _showNotifications = !_showNotifications),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_none_rounded,
                    color: Color(0xFF374151)),
                if (unreadCount > 0)
                  Positioned(
                    right: 1,
                    top: 1,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14, left: 4),
            child: GestureDetector(
              onTap: () => setState(() {
                _showNotifications = false;
                _tabIndex = 5;
              }),
              child: CircleAvatar(
                radius: 17,
                backgroundColor: const Color(0xFF0E7C3A),
                child: Text(
                  _initials(_settings.ownerName),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tabIndex,
        onTap: (i) => setState(() {
          _showNotifications = false;
          _tabIndex = i;
        }),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0E7C3A),
        unselectedItemColor: const Color(0xFF9CA3AF),
        selectedFontSize: 11,
        unselectedFontSize: 11,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home_rounded),
              label: isUr ? 'ڈیش بورڈ' : 'Dashboard'),
          BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: isUr ? 'کاشتکار' : 'Farmers'),
          BottomNavigationBarItem(
              icon: const Icon(Icons.groups_outlined),
              activeIcon: const Icon(Icons.groups),
              label: isUr ? 'خریدار' : 'Buyers'),
          BottomNavigationBarItem(
              icon: const Icon(Icons.inbox_outlined),
              activeIcon: const Icon(Icons.inbox),
              label: isUr ? 'آمد' : 'Arrival'),
          BottomNavigationBarItem(
              icon: const Icon(Icons.bar_chart_outlined),
              activeIcon: const Icon(Icons.bar_chart_rounded),
              label: isUr ? 'نیلامی' : 'Auction'),
          BottomNavigationBarItem(
              icon: const Icon(Icons.menu),
              activeIcon: const Icon(Icons.menu),
              label: isUr ? 'مزید' : 'More'),
        ],
      ),
    );
    }

    return AppLang(
      language: _settings.language,
      onChangeLanguage: (lang) {
        setState(() => _settings.language = lang);
        _persist();
      },
      child: content,
    );
  }
}

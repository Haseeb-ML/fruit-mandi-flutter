export 'local_store.dart';

String formatRs(int amount) {
  return 'Rs ${formatIndianNumber(amount)}';
}

String formatIndianNumber(int number) {
  final isNeg = number < 0;
  final str = number.abs().toString();
  if (str.length <= 3) return '${isNeg ? '-' : ''}$str';
  final last3 = str.substring(str.length - 3);
  final rest = str.substring(0, str.length - 3);
  final buf = StringBuffer();
  for (int i = 0; i < rest.length; i++) {
    final posFromRight = rest.length - i;
    buf.write(rest[i]);
    if (posFromRight > 1 && posFromRight % 2 == 1) {
      buf.write(',');
    }
  }
  return '${isNeg ? '-' : ''}${buf.toString()},$last3';
}

class MandiSettings {
  String companyName;
  String ownerName;
  String phone;
  String city;
  String licenseNo;
  String address;
  double defaultCommissionPercent;
  double marketFeePercent;
  String language;

  MandiSettings({
    required this.companyName,
    required this.ownerName,
    required this.phone,
    required this.city,
    required this.licenseNo,
    required this.address,
    required this.defaultCommissionPercent,
    required this.marketFeePercent,
    this.language = 'en',
  });

  factory MandiSettings.defaults() => MandiSettings(
        companyName: 'Al-Barkat Commission Agents',
        ownerName: 'Haji Abdul Karim',
        phone: '0300-1234567',
        city: 'Lahore',
        licenseNo: 'MLA-2025-001',
        address: 'Shop #12, Fruit Mandi, Lahore',
        defaultCommissionPercent: 6.0,
        marketFeePercent: 0.5,
        language: 'en',
      );

  Map<String, dynamic> toJson() => {
        'companyName': companyName,
        'ownerName': ownerName,
        'phone': phone,
        'city': city,
        'licenseNo': licenseNo,
        'address': address,
        'defaultCommissionPercent': defaultCommissionPercent,
        'marketFeePercent': marketFeePercent,
        'language': language,
      };

  factory MandiSettings.fromJson(Map<String, dynamic> json) => MandiSettings(
        companyName: json['companyName'] ?? 'Al-Barkat Commission Agents',
        ownerName: json['ownerName'] ?? 'Haji Abdul Karim',
        phone: json['phone'] ?? '0300-1234567',
        city: json['city'] ?? 'Lahore',
        licenseNo: json['licenseNo'] ?? 'MLA-2025-001',
        address: json['address'] ?? 'Shop #12, Fruit Mandi, Lahore',
        defaultCommissionPercent:
            (json['defaultCommissionPercent'] as num?)?.toDouble() ?? 6.0,
        marketFeePercent:
            (json['marketFeePercent'] as num?)?.toDouble() ?? 0.5,
        language: json['language'] == 'ur' ? 'ur' : 'en',
      );
}

class Farmer {
  final String id;
  String name;
  String phone;
  String village;
  String address;
  String cnic;
  String fruit;
  int balance;
  String balanceType; // Payable | Receivable | Settled

  Farmer({
    required this.id,
    required this.name,
    required this.phone,
    required this.village,
    this.address = '',
    this.cnic = '',
    required this.fruit,
    this.balance = 0,
    this.balanceType = 'Settled',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'village': village,
        'address': address,
        'cnic': cnic,
        'fruit': fruit,
        'balance': balance,
        'balanceType': balanceType,
      };

  factory Farmer.fromJson(Map<String, dynamic> json) => Farmer(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        phone: json['phone'] ?? '',
        village: json['village'] ?? '',
        address: json['address'] ?? '',
        cnic: json['cnic'] ?? '',
        fruit: json['fruit'] ?? 'Mango',
        balance: (json['balance'] as num?)?.toInt() ?? 0,
        balanceType: json['balanceType'] ?? 'Settled',
      );
}

class Buyer {
  final String id;
  String businessName;
  String contactName;
  String phone;
  String mandi;
  int outstanding;
  int creditLimit;

  Buyer({
    required this.id,
    required this.businessName,
    required this.contactName,
    required this.phone,
    required this.mandi,
    this.outstanding = 0,
    this.creditLimit = 50000,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'businessName': businessName,
        'contactName': contactName,
        'phone': phone,
        'mandi': mandi,
        'outstanding': outstanding,
        'creditLimit': creditLimit,
      };

  factory Buyer.fromJson(Map<String, dynamic> json) => Buyer(
        id: json['id'] ?? '',
        businessName: json['businessName'] ?? '',
        contactName: json['contactName'] ?? '',
        phone: json['phone'] ?? '',
        mandi: json['mandi'] ?? '',
        outstanding: (json['outstanding'] as num?)?.toInt() ?? 0,
        creditLimit: (json['creditLimit'] as num?)?.toInt() ?? 50000,
      );
}

class ArrivalEntry {
  final String id;
  String date;
  String farmerName;
  String fruit;
  String grade;
  int boxes;
  int weightKg;

  ArrivalEntry({
    required this.id,
    required this.date,
    required this.farmerName,
    required this.fruit,
    required this.grade,
    required this.boxes,
    required this.weightKg,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'date': date,
        'farmerName': farmerName,
        'fruit': fruit,
        'grade': grade,
        'boxes': boxes,
        'weightKg': weightKg,
      };

  factory ArrivalEntry.fromJson(Map<String, dynamic> json) => ArrivalEntry(
        id: json['id'] ?? '',
        date: json['date'] ?? '',
        farmerName: json['farmerName'] ?? '',
        fruit: json['fruit'] ?? 'Mango',
        grade: json['grade'] ?? 'A-Grade',
        boxes: (json['boxes'] as num?)?.toInt() ?? 0,
        weightKg: (json['weightKg'] as num?)?.toInt() ?? 0,
      );
}

class AuctionEntry {
  final String id;
  final String code;
  final String date;
  final String fruit;
  final String grade;
  final String farmerName;
  final String buyerName;
  final int boxes;
  final int rate;
  final int commission;
  final int net;

  AuctionEntry({
    required this.id,
    required this.code,
    required this.date,
    required this.fruit,
    required this.grade,
    required this.farmerName,
    required this.buyerName,
    required this.boxes,
    required this.rate,
    required this.commission,
    required this.net,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'date': date,
        'fruit': fruit,
        'grade': grade,
        'farmerName': farmerName,
        'buyerName': buyerName,
        'boxes': boxes,
        'rate': rate,
        'commission': commission,
        'net': net,
      };

  factory AuctionEntry.fromJson(Map<String, dynamic> json) => AuctionEntry(
        id: json['id'] ?? '',
        code: json['code'] ?? '',
        date: json['date'] ?? '',
        fruit: json['fruit'] ?? 'Mango',
        grade: json['grade'] ?? 'A-Grade',
        farmerName: json['farmerName'] ?? '',
        buyerName: json['buyerName'] ?? '',
        boxes: (json['boxes'] as num?)?.toInt() ?? 0,
        rate: (json['rate'] as num?)?.toInt() ?? 0,
        commission: (json['commission'] as num?)?.toInt() ?? 0,
        net: (json['net'] as num?)?.toInt() ?? 0,
      );
}

class MandiNotification {
  final String id;
  final String title;
  final String urdu;
  final String message;
  final String time;
  final String variant;
  bool unread;

  MandiNotification({
    required this.id,
    required this.title,
    required this.urdu,
    required this.message,
    required this.time,
    required this.variant,
    this.unread = true,
  });
}

class MandiTransaction {
  final String id;
  final String title;
  final String subtitle;
  final int amount;
  final bool isDebit;
  final String category;

  MandiTransaction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isDebit,
    required this.category,
  });
}

class WeeklyDaySale {
  final String day;
  final int sales;
  final int commission;

  const WeeklyDaySale(this.day, this.sales, this.commission);
}

const initialWeeklySales = [
  WeeklyDaySale('Mon', 142000, 8520),
  WeeklyDaySale('Tue', 198000, 11880),
  WeeklyDaySale('Wed', 162000, 9720),
  WeeklyDaySale('Thu', 220000, 13200),
  WeeklyDaySale('Fri', 185000, 11100),
  WeeklyDaySale('Sat', 254000, 15240),
  WeeklyDaySale('Sun', 189000, 11340),
];

List<Farmer> initialFarmers() => [
      Farmer(
        id: 'f1',
        name: 'Muhammad Ali Khan',
        phone: '0301-2345678',
        village: 'Multan',
        address: 'Chowk Kumharan, Multan',
        fruit: 'Mango',
        balance: 45000,
        balanceType: 'Payable',
      ),
      Farmer(
        id: 'f2',
        name: 'Ghulam Hussain',
        phone: '0311-9876543',
        village: 'Rahim Yar Khan',
        address: 'Near Water Canal, RYK',
        fruit: 'Citrus',
        balance: 12000,
        balanceType: 'Receivable',
      ),
      Farmer(
        id: 'f3',
        name: 'Abdul Razzaq',
        phone: '0333-7654321',
        village: 'Khanpur',
        address: 'Main Bazaar Khanpur',
        fruit: 'Banana',
        balance: 78000,
        balanceType: 'Payable',
      ),
      Farmer(
        id: 'f4',
        name: 'Tariq Mehmood',
        phone: '0321-1112233',
        village: 'Bahawalpur',
        address: 'Chishti Colony, BWP',
        fruit: 'Apple',
        balance: 0,
        balanceType: 'Settled',
      ),
      Farmer(
        id: 'f5',
        name: 'Nazir Ahmed',
        phone: '0305-9988774',
        village: 'Sahiwal',
        address: 'GT Road, Sahiwal',
        fruit: 'Mango',
        balance: 22500,
        balanceType: 'Payable',
      ),
    ];

List<Buyer> initialBuyers() => [
      Buyer(
        id: 'b1',
        businessName: 'Khan Fruit Centre',
        contactName: 'Asif Khan',
        phone: '0300-1122334',
        mandi: 'Lahore Mandi',
        outstanding: 85000,
        creditLimit: 200000,
      ),
      Buyer(
        id: 'b2',
        businessName: 'Al-Madina Fruit Store',
        contactName: 'Tariq Jamil',
        phone: '0321-9988776',
        mandi: 'Multan Mandi',
        outstanding: 45000,
        creditLimit: 100000,
      ),
      Buyer(
        id: 'b3',
        businessName: 'Fruit Palace',
        contactName: 'Rana Usman',
        phone: '0333-5544332',
        mandi: 'Faisalabad Mandi',
        outstanding: 120000,
        creditLimit: 150000,
      ),
      Buyer(
        id: 'b4',
        businessName: 'City Fruit Market',
        contactName: 'Bilal Sheikh',
        phone: '0345-6677889',
        mandi: 'Gujranwala Mandi',
        outstanding: 32000,
        creditLimit: 120000,
      ),
      Buyer(
        id: 'b5',
        businessName: 'Lahore Fresh Mart',
        contactName: 'Kamran Butt',
        phone: '0312-4433221',
        mandi: 'Lahore Mandi',
        outstanding: 18000,
        creditLimit: 100000,
      ),
    ];

List<ArrivalEntry> initialArrivals() => [
      ArrivalEntry(
        id: 'arr1',
        date: '2025-07-17',
        farmerName: 'Muhammad Ali Khan',
        fruit: 'Mango',
        grade: 'A-Grade',
        boxes: 80,
        weightKg: 1600,
      ),
      ArrivalEntry(
        id: 'arr2',
        date: '2025-07-17',
        farmerName: 'Ghulam Hussain',
        fruit: 'Citrus',
        grade: 'B-Grade',
        boxes: 60,
        weightKg: 1200,
      ),
      ArrivalEntry(
        id: 'arr3',
        date: '2025-07-16',
        farmerName: 'Abdul Razzaq',
        fruit: 'Banana',
        grade: 'A-Grade',
        boxes: 120,
        weightKg: 2400,
      ),
      ArrivalEntry(
        id: 'arr4',
        date: '2025-07-16',
        farmerName: 'Nazir Ahmed',
        fruit: 'Mango',
        grade: 'A-Grade',
        boxes: 95,
        weightKg: 1900,
      ),
    ];

List<AuctionEntry> initialAuctions() => [
      AuctionEntry(
        id: 'AUC-0142',
        code: '0142',
        date: '2025-07-17',
        fruit: 'Mango',
        grade: 'A-Grade',
        farmerName: 'Muhammad Ali Khan',
        buyerName: 'Khan Fruit Centre',
        boxes: 80,
        rate: 600,
        commission: 2880,
        net: 45120,
      ),
      AuctionEntry(
        id: 'AUC-0141',
        code: '0141',
        date: '2025-07-17',
        fruit: 'Banana',
        grade: 'A-Grade',
        farmerName: 'Abdul Razzaq',
        buyerName: 'Fruit Palace',
        boxes: 120,
        rate: 300,
        commission: 2160,
        net: 33840,
      ),
      AuctionEntry(
        id: 'AUC-0140',
        code: '0140',
        date: '2025-07-16',
        fruit: 'Citrus',
        grade: 'B-Grade',
        farmerName: 'Ghulam Hussain',
        buyerName: 'City Fruit Market',
        boxes: 60,
        rate: 700,
        commission: 2100,
        net: 39900,
      ),
    ];

List<MandiTransaction> initialTransactions() => [
      MandiTransaction(
        id: 'AUC-0142',
        title: 'Ali Farms → Khan Market',
        subtitle: 'Mango A-Grade · 80 boxes',
        amount: 48000,
        isDebit: false,
        category: 'auction',
      ),
      MandiTransaction(
        id: 'PAY-0089',
        title: 'Raza Brothers (Buyer)',
        subtitle: 'Payment Received',
        amount: 35000,
        isDebit: false,
        category: 'payment',
      ),
      MandiTransaction(
        id: 'AUC-0141',
        title: 'Hussain Agro → City Fruit',
        subtitle: 'Apple · 60 boxes',
        amount: 42000,
        isDebit: false,
        category: 'auction',
      ),
      MandiTransaction(
        id: 'EXP-0034',
        title: 'Labour Expense',
        subtitle: 'Unloading — 24 lots',
        amount: 3600,
        isDebit: true,
        category: 'expense',
      ),
      MandiTransaction(
        id: 'AUC-0140',
        title: 'Sindhi Farm → Fruit Palace',
        subtitle: 'Banana · 120 boxes',
        amount: 36000,
        isDebit: false,
        category: 'auction',
      ),
    ];

List<MandiNotification> initialNotifications() => [
      MandiNotification(
        id: 'n1',
        title: 'Pending Payment',
        urdu: 'باقی ادائیگی',
        message: 'Khan Fruit Centre has Rs85,000 outstanding since 5 days',
        time: '2 hrs ago',
        variant: 'warning',
        unread: true,
      ),
      MandiNotification(
        id: 'n2',
        title: "Today's Arrival Reminder",
        urdu: 'آج کی آمد یاد دہانی',
        message: '3 farmers expected to arrive today. Prepare receiving area.',
        time: '4 hrs ago',
        variant: 'info',
        unread: true,
      ),
      MandiNotification(
        id: 'n3',
        title: 'Credit Limit Alert',
        urdu: 'کریڈٹ حد خبردار',
        message:
            'Fruit Palace has reached 80% of credit limit (Rs120,000/Rs150,000)',
        time: '6 hrs ago',
        variant: 'danger',
        unread: true,
      ),
      MandiNotification(
        id: 'n4',
        title: 'Outstanding Farmer',
        urdu: 'باقی کاشتکار',
        message: 'Ghulam Hussain payment of Rs12,000 is overdue by 3 days',
        time: 'Yesterday',
        variant: 'warning',
        unread: false,
      ),
      MandiNotification(
        id: 'n5',
        title: 'Payment Received',
        urdu: 'ادائیگی ملی',
        message: 'City Fruit Market paid Rs30,000 — Balance updated',
        time: 'Yesterday',
        variant: 'success',
        unread: false,
      ),
      MandiNotification(
        id: 'n6',
        title: 'Weekly Report Ready',
        urdu: 'ہفتہ وار رپورٹ',
        message: 'Your weekly summary report for July 14-17 is ready',
        time: '2 days ago',
        variant: 'info',
        unread: false,
      ),
    ];


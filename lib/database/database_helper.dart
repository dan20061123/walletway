import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const int currentDbVersion = 3; // Increment this version
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'walletway.db');

    print("DB path is: $dbPath");
    print("DB name is: walletway.db");

    return await openDatabase(path,
        version: DatabaseHelper.currentDbVersion, onCreate: _createDb);
  }

  Future<void> migrateDatabase(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Step 1: Refactor budgets table
      await db.execute('''
      CREATE TABLE budgets_new (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        category_id INTEGER,
        amount REAL NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
      ''');

      // await db.execute('''
      //   INSERT INTO budgets_new (id, type, category_id, amount)
      //   SELECT id, type, category_id, amount FROM budgets
      // ''');

      await db.execute('DROP TABLE budgets');
      await db.execute('ALTER TABLE budgets_new RENAME TO budgets');

      // Step 2: Create currencies table
      await db.execute('''
      CREATE TABLE IF NOT EXISTS currencies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        iso_code TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        symbol TEXT NOT NULL
      )
      ''');

      // Step 3: Insert initial currencies data
      // Step 3: Insert initial currencies data
      await db.execute('''
      INSERT INTO currencies (iso_code, name, symbol) VALUES
      ('AED', 'United Arab Emirates Dirham', 'د.إ'),
      ('AFN', 'Afghan Afghani', '؋'),
      ('ALL', 'Albanian Lek', 'L'),
      ('AMD', 'Armenian Dram', '֏'),
      ('ANG', 'Netherlands Antillean Guilder', 'ƒ'),
      ('AOA', 'Angolan Kwanza', 'Kz'),
      ('ARS', 'Argentine Peso', '\$'),
      ('AUD', 'Australian Dollar', 'A\$'),
      ('AWG', 'Aruban Florin', 'ƒ'),
      ('AZN', 'Azerbaijani Manat', '₼'),
      ('BAM', 'Bosnia-Herzegovina Convertible Mark', 'KM'),
      ('BBD', 'Barbadian Dollar', 'Bds\$'),
      ('BDT', 'Bangladeshi Taka', '৳'),
      ('BGN', 'Bulgarian Lev', 'лв'),
      ('BHD', 'Bahraini Dinar', '.د.ب'),
      ('BIF', 'Burundian Franc', 'FBu'),
      ('BMD', 'Bermudian Dollar', '\$'),
      ('BND', 'Brunei Dollar', 'B\$'),
      ('BOB', 'Bolivian Boliviano', 'Bs.'),
      ('BRL', 'Brazilian Real', 'R\$'),
      ('BSD', 'Bahamian Dollar', '\$'),
      ('BTN', 'Bhutanese Ngultrum', 'Nu.'),
      ('BWP', 'Botswana Pula', 'P'),
      ('BYN', 'Belarusian Ruble', 'Br'),
      ('BZD', 'Belize Dollar', 'BZ\$'),
      ('CAD', 'Canadian Dollar', 'C\$'),
      ('CDF', 'Congolese Franc', 'FC'),
      ('CHF', 'Swiss Franc', 'CHF'),
      ('CLP', 'Chilean Peso', '\$'),
      ('CNY', 'Chinese Yuan', '¥'),
      ('COP', 'Colombian Peso', '\$'),
      ('CRC', 'Costa Rican Colón', '₡'),
      ('CUP', 'Cuban Peso', '\$'),
      ('CVE', 'Cape Verdean Escudo', '\$'),
      ('CZK', 'Czech Koruna', 'Kč'),
      ('DJF', 'Djiboutian Franc', 'Fdj'),
      ('DKK', 'Danish Krone', 'kr'),
      ('DOP', 'Dominican Peso', '\$'),
      ('DZD', 'Algerian Dinar', 'د.ج'),
      ('EGP', 'Egyptian Pound', '£'),
      ('ERN', 'Eritrean Nakfa', 'ናቕፋ'),
      ('ETB', 'Ethiopian Birr', 'Br'),
      ('EUR', 'Euro', '€'),
      ('FJD', 'Fijian Dollar', '\$'),
      ('FKP', 'Falkland Islands Pound', '£'),
      ('FOK', 'Faroese Króna', 'kr'),
      ('GBP', 'British Pound', '£'),
      ('GEL', 'Georgian Lari', '₾'),
      ('GGP', 'Guernsey Pound', '£'),
      ('GHS', 'Ghanaian Cedi', '₵'),
      ('GIP', 'Gibraltar Pound', '£'),
      ('GMD', 'Gambian Dalasi', 'D'),
      ('GNF', 'Guinean Franc', 'FG'),
      ('GTQ', 'Guatemalan Quetzal', 'Q'),
      ('GYD', 'Guyanese Dollar', '\$'),
      ('HKD', 'Hong Kong Dollar', 'HK\$'),
      ('HNL', 'Honduran Lempira', 'L'),
      ('HRK', 'Croatian Kuna', 'kn'),
      ('HTG', 'Haitian Gourde', 'G'),
      ('HUF', 'Hungarian Forint', 'Ft'),
      ('IDR', 'Indonesian Rupiah', 'Rp'),
      ('ILS', 'Israeli New Shekel', '₪'),
      ('IMP', 'Isle of Man Pound', '£'),
      ('INR', 'Indian Rupee', '₹'),
      ('IQD', 'Iraqi Dinar', 'ع.د'),
      ('IRR', 'Iranian Rial', '﷼'),
      ('ISK', 'Icelandic Króna', 'kr'),
      ('JEP', 'Jersey Pound', '£'),
      ('JMD', 'Jamaican Dollar', 'J\$'),
      ('JOD', 'Jordanian Dinar', 'د.ا'),
      ('JPY', 'Japanese Yen', '¥'),
      ('KES', 'Kenyan Shilling', 'KSh'),
      ('KGS', 'Kyrgyzstani Som', 'с'),
      ('KHR', 'Cambodian Riel', '៛'),
      ('KID', 'Kiribati Dollar', '\$'),
      ('KMF', 'Comorian Franc', 'CF'),
      ('KRW', 'South Korean Won', '₩'),
      ('KWD', 'Kuwaiti Dinar', 'د.ك'),
      ('KYD', 'Cayman Islands Dollar', '\$'),
      ('KZT', 'Kazakhstani Tenge', '₸'),
      ('LAK', 'Lao Kip', '₭'),
      ('LBP', 'Lebanese Pound', 'ل.ل'),
      ('LKR', 'Sri Lankan Rupee', 'Rs'),
      ('LRD', 'Liberian Dollar', '\$'),
      ('LSL', 'Lesotho Loti', 'L'),
      ('LYD', 'Libyan Dinar', 'ل.د'),
      ('MAD', 'Moroccan Dirham', 'د.م.'),
      ('MDL', 'Moldovan Leu', 'L'),
      ('MGA', 'Malagasy Ariary', 'Ar'),
      ('MKD', 'Macedonian Denar', 'ден'),
      ('MMK', 'Burmese Kyat', 'K'),
      ('MNT', 'Mongolian Tögrög', '₮'),
      ('MOP', 'Macanese Pataca', 'MOP\$'),
      ('MRU', 'Mauritanian Ouguiya', 'UM'),
      ('MUR', 'Mauritian Rupee', '₨'),
      ('MVR', 'Maldivian Rufiyaa', 'ރ'),
      ('MWK', 'Malawian Kwacha', 'MK'),
      ('MXN', 'Mexican Peso', '\$'),
      ('MYR', 'Malaysian Ringgit', 'RM'),
      ('MZN', 'Mozambican Metical', 'MT'),
      ('NAD', 'Namibian Dollar', '\$'),
      ('NGN', 'Nigerian Naira', '₦'),
      ('NIO', 'Nicaraguan Córdoba', 'C\$'),
      ('NOK', 'Norwegian Krone', 'kr'),
      ('NPR', 'Nepalese Rupee', '₨'),
      ('NZD', 'New Zealand Dollar', 'NZ\$'),
      ('OMR', 'Omani Rial', 'ر.ع.'),
      ('PAB', 'Panamanian Balboa', 'B/.'),
      ('PEN', 'Peruvian Sol', 'S/'),
      ('PGK', 'Papua New Guinean Kina', 'K'),
      ('PHP', 'Philippine Peso', '₱'),
      ('PKR', 'Pakistani Rupee', '₨'),
      ('PLN', 'Polish Złoty', 'zł'),
      ('PYG', 'Paraguayan Guaraní', '₲'),
      ('QAR', 'Qatari Riyal', 'ر.ق'),
      ('RON', 'Romanian Leu', 'lei'),
      ('RSD', 'Serbian Dinar', 'дин'),
      ('RUB', 'Russian Ruble', '₽'),
      ('RWF', 'Rwandan Franc', 'FRw'),
      ('SAR', 'Saudi Riyal', 'ر.س'),
      ('SBD', 'Solomon Islands Dollar', 'SI\$'),
      ('SCR', 'Seychellois Rupee', '₨'),
      ('SDG', 'Sudanese Pound', 'ج.س.'),
      ('SEK', 'Swedish Krona', 'kr'),
      ('SGD', 'Singapore Dollar', 'S\$'),
      ('SHP', 'Saint Helena Pound', '£'),
      ('SLL', 'Sierra Leonean Leone', 'Le'),
      ('SOS', 'Somali Shilling', 'Sh'),
      ('SRD', 'Surinamese Dollar', '\$'),
      ('SSP', 'South Sudanese Pound', '£'),
      ('STN', 'São Tomé and Príncipe Dobra', 'Db'),
      ('SYP', 'Syrian Pound', '£'),
      ('SZL', 'Eswatini Lilangeni', 'L'),
      ('THB', 'Thai Baht', '฿'),
      ('TJS', 'Tajikistani Somoni', 'ЅМ'),
      ('TMT', 'Turkmenistani Manat', 'm'),
      ('TND', 'Tunisian Dinar', 'د.ت'),
      ('TOP', 'Tongan Paʻanga', 'T\$'),
      ('TRY', 'Turkish Lira', '₺'),
      ('TTD', 'Trinidad and Tobago Dollar', 'TT\$'),
      ('TVD', 'Tuvaluan Dollar', '\$'),
      ('TZS', 'Tanzanian Shilling', 'TSh'),
      ('UAH', 'Ukrainian Hryvnia', '₴'),
      ('UGX', 'Ugandan Shilling', 'USh'),
      ('USD', 'US Dollar', '\$'),
      ('UYU', 'Uruguayan Peso', '\$U'),
      ('UZS', 'Uzbekistani Soʻm', 'soʻm'),
      ('VES', 'Venezuelan Bolívar', 'Bs.'),
      ('VND', 'Vietnamese Đồng', '₫'),
      ('VUV', 'Vanuatu Vatu', 'Vt'),
      ('WST', 'Samoan Tālā', 'WS\$'),
      ('XAF', 'Central African CFA Franc', 'FCFA'),
      ('XCD', 'East Caribbean Dollar', 'EC\$'),
      ('XOF', 'West African CFA Franc', 'CFA'),
      ('XPF', 'CFP Franc', '₣'),
      ('YER', 'Yemeni Rial', '﷼'),
      ('ZAR', 'South African Rand', 'R'),
      ('ZMW', 'Zambian Kwacha', 'ZK'),
      ('ZWL', 'Zimbabwean Dollar', 'Z\$');
    ''');
    }
  }

  Future<void> migrateBudgetsTable(Database db) async {
    await db.execute('''
    CREATE TABLE budgets_new (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      type TEXT NOT NULL,
      category_id INTEGER,
      amount REAL NOT NULL,
      FOREIGN KEY (category_id) REFERENCES categories (id)
    )
  ''');

    //   // Migrate data from old table to new table
    //   await db.execute('''
    //   INSERT INTO budgets_new (id, type, category_id, amount)
    //   SELECT id, type, category_id, amount FROM budgets
    // ''');

    // Drop the old table
    await db.execute('DROP TABLE budgets');

    // Rename new table to old table name
    await db.execute('ALTER TABLE budgets_new RENAME TO budgets');
  }

  Future<void> _createDb(Database db, int version) async {
    // Create categories table
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        icon_name TEXT NOT NULL,
        type TEXT NOT NULL -- "spending", "income", or "both"
      )
    ''');

    // Create transactions table
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        category INTEGER NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (category) REFERENCES categories (id)
      )
    ''');

    // Create budgets table
    await db.execute('''
      CREATE TABLE budgets (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        category_id INTEGER,
        amount REAL NOT NULL,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    // Create currencies table
    await db.execute('''
      CREATE TABLE currencies (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        iso_code TEXT NOT NULL UNIQUE, -- ISO 4217 currency code (e.g., USD, EUR)
        name TEXT NOT NULL,           -- Full currency name (e.g., US Dollar)
        symbol TEXT NOT NULL          -- Currency symbol (e.g., \$, €)
      )
    ''');

    // Insert default categories with updated types
    List<Map<String, String>> initialCategories = [
      {
        'category': 'Groceries',
        'icon_name': 'shopping_cart',
        'type': 'spending'
      },
      {
        'category': 'Restaurants',
        'icon_name': 'restaurant',
        'type': 'spending'
      },
      {
        'category': 'Fitness',
        'icon_name': 'fitness_center',
        'type': 'spending'
      },
      {'category': 'Entertainment', 'icon_name': 'movie', 'type': 'spending'},
      {'category': 'Health', 'icon_name': 'local_hospital', 'type': 'spending'},
      {'category': 'School Fees', 'icon_name': 'school', 'type': 'spending'},
      {
        'category': 'Public Transportation',
        'icon_name': 'directions_bus',
        'type': 'spending'
      },
      {'category': 'Car', 'icon_name': 'directions_car', 'type': 'spending'},
      {'category': 'Rent', 'icon_name': 'home', 'type': 'both'}, // Updated
      {'category': 'Utilities', 'icon_name': 'lightbulb', 'type': 'spending'},
      {'category': 'Insurance', 'icon_name': 'security', 'type': 'spending'},
      {'category': 'Clothing', 'icon_name': 'checkroom', 'type': 'spending'},
      {
        'category': 'Household Supplies',
        'icon_name': 'cleaning_services',
        'type': 'spending'
      },
      {'category': 'Education', 'icon_name': 'book', 'type': 'spending'},
      {
        'category': 'Personal Care',
        'icon_name': 'self_improvement',
        'type': 'spending'
      },
      {'category': 'Travel', 'icon_name': 'flight', 'type': 'spending'},
      {
        'category': 'Hobbies',
        'icon_name': 'sports_esports',
        'type': 'spending'
      },
      {'category': 'Gifts', 'icon_name': 'card_giftcard', 'type': 'both'},
      {'category': 'Miscellaneous', 'icon_name': 'category', 'type': 'both'},
      {'category': 'Salary', 'icon_name': 'attach_money', 'type': 'income'},
      {
        'category': 'Dividends',
        'icon_name': 'monetization_on',
        'type': 'income'
      },
      {'category': 'Freelance', 'icon_name': 'work', 'type': 'income'},
      {'category': 'Investment', 'icon_name': 'trending_up', 'type': 'income'},
      {'category': 'Bonus', 'icon_name': 'star', 'type': 'income'},
    ];

    for (var category in initialCategories) {
      await db.insert('categories', category);
    }

    // Step 3: Insert initial currencies data
    await db.execute('''
      INSERT INTO currencies (iso_code, name, symbol) VALUES
      ('AED', 'United Arab Emirates Dirham', 'د.إ'),
      ('AFN', 'Afghan Afghani', '؋'),
      ('ALL', 'Albanian Lek', 'L'),
      ('AMD', 'Armenian Dram', '֏'),
      ('ANG', 'Netherlands Antillean Guilder', 'ƒ'),
      ('AOA', 'Angolan Kwanza', 'Kz'),
      ('ARS', 'Argentine Peso', '\$'),
      ('AUD', 'Australian Dollar', 'A\$'),
      ('AWG', 'Aruban Florin', 'ƒ'),
      ('AZN', 'Azerbaijani Manat', '₼'),
      ('BAM', 'Bosnia-Herzegovina Convertible Mark', 'KM'),
      ('BBD', 'Barbadian Dollar', 'Bds\$'),
      ('BDT', 'Bangladeshi Taka', '৳'),
      ('BGN', 'Bulgarian Lev', 'лв'),
      ('BHD', 'Bahraini Dinar', '.د.ب'),
      ('BIF', 'Burundian Franc', 'FBu'),
      ('BMD', 'Bermudian Dollar', '\$'),
      ('BND', 'Brunei Dollar', 'B\$'),
      ('BOB', 'Bolivian Boliviano', 'Bs.'),
      ('BRL', 'Brazilian Real', 'R\$'),
      ('BSD', 'Bahamian Dollar', '\$'),
      ('BTN', 'Bhutanese Ngultrum', 'Nu.'),
      ('BWP', 'Botswana Pula', 'P'),
      ('BYN', 'Belarusian Ruble', 'Br'),
      ('BZD', 'Belize Dollar', 'BZ\$'),
      ('CAD', 'Canadian Dollar', 'C\$'),
      ('CDF', 'Congolese Franc', 'FC'),
      ('CHF', 'Swiss Franc', 'CHF'),
      ('CLP', 'Chilean Peso', '\$'),
      ('CNY', 'Chinese Yuan', '¥'),
      ('COP', 'Colombian Peso', '\$'),
      ('CRC', 'Costa Rican Colón', '₡'),
      ('CUP', 'Cuban Peso', '\$'),
      ('CVE', 'Cape Verdean Escudo', '\$'),
      ('CZK', 'Czech Koruna', 'Kč'),
      ('DJF', 'Djiboutian Franc', 'Fdj'),
      ('DKK', 'Danish Krone', 'kr'),
      ('DOP', 'Dominican Peso', '\$'),
      ('DZD', 'Algerian Dinar', 'د.ج'),
      ('EGP', 'Egyptian Pound', '£'),
      ('ERN', 'Eritrean Nakfa', 'ናቕፋ'),
      ('ETB', 'Ethiopian Birr', 'Br'),
      ('EUR', 'Euro', '€'),
      ('FJD', 'Fijian Dollar', '\$'),
      ('FKP', 'Falkland Islands Pound', '£'),
      ('FOK', 'Faroese Króna', 'kr'),
      ('GBP', 'British Pound', '£'),
      ('GEL', 'Georgian Lari', '₾'),
      ('GGP', 'Guernsey Pound', '£'),
      ('GHS', 'Ghanaian Cedi', '₵'),
      ('GIP', 'Gibraltar Pound', '£'),
      ('GMD', 'Gambian Dalasi', 'D'),
      ('GNF', 'Guinean Franc', 'FG'),
      ('GTQ', 'Guatemalan Quetzal', 'Q'),
      ('GYD', 'Guyanese Dollar', '\$'),
      ('HKD', 'Hong Kong Dollar', 'HK\$'),
      ('HNL', 'Honduran Lempira', 'L'),
      ('HRK', 'Croatian Kuna', 'kn'),
      ('HTG', 'Haitian Gourde', 'G'),
      ('HUF', 'Hungarian Forint', 'Ft'),
      ('IDR', 'Indonesian Rupiah', 'Rp'),
      ('ILS', 'Israeli New Shekel', '₪'),
      ('IMP', 'Isle of Man Pound', '£'),
      ('INR', 'Indian Rupee', '₹'),
      ('IQD', 'Iraqi Dinar', 'ع.د'),
      ('IRR', 'Iranian Rial', '﷼'),
      ('ISK', 'Icelandic Króna', 'kr'),
      ('JEP', 'Jersey Pound', '£'),
      ('JMD', 'Jamaican Dollar', 'J\$'),
      ('JOD', 'Jordanian Dinar', 'د.ا'),
      ('JPY', 'Japanese Yen', '¥'),
      ('KES', 'Kenyan Shilling', 'KSh'),
      ('KGS', 'Kyrgyzstani Som', 'с'),
      ('KHR', 'Cambodian Riel', '៛'),
      ('KID', 'Kiribati Dollar', '\$'),
      ('KMF', 'Comorian Franc', 'CF'),
      ('KRW', 'South Korean Won', '₩'),
      ('KWD', 'Kuwaiti Dinar', 'د.ك'),
      ('KYD', 'Cayman Islands Dollar', '\$'),
      ('KZT', 'Kazakhstani Tenge', '₸'),
      ('LAK', 'Lao Kip', '₭'),
      ('LBP', 'Lebanese Pound', 'ل.ل'),
      ('LKR', 'Sri Lankan Rupee', 'Rs'),
      ('LRD', 'Liberian Dollar', '\$'),
      ('LSL', 'Lesotho Loti', 'L'),
      ('LYD', 'Libyan Dinar', 'ل.د'),
      ('MAD', 'Moroccan Dirham', 'د.م.'),
      ('MDL', 'Moldovan Leu', 'L'),
      ('MGA', 'Malagasy Ariary', 'Ar'),
      ('MKD', 'Macedonian Denar', 'ден'),
      ('MMK', 'Burmese Kyat', 'K'),
      ('MNT', 'Mongolian Tögrög', '₮'),
      ('MOP', 'Macanese Pataca', 'MOP\$'),
      ('MRU', 'Mauritanian Ouguiya', 'UM'),
      ('MUR', 'Mauritian Rupee', '₨'),
      ('MVR', 'Maldivian Rufiyaa', 'ރ'),
      ('MWK', 'Malawian Kwacha', 'MK'),
      ('MXN', 'Mexican Peso', '\$'),
      ('MYR', 'Malaysian Ringgit', 'RM'),
      ('MZN', 'Mozambican Metical', 'MT'),
      ('NAD', 'Namibian Dollar', '\$'),
      ('NGN', 'Nigerian Naira', '₦'),
      ('NIO', 'Nicaraguan Córdoba', 'C\$'),
      ('NOK', 'Norwegian Krone', 'kr'),
      ('NPR', 'Nepalese Rupee', '₨'),
      ('NZD', 'New Zealand Dollar', 'NZ\$'),
      ('OMR', 'Omani Rial', 'ر.ع.'),
      ('PAB', 'Panamanian Balboa', 'B/.'),
      ('PEN', 'Peruvian Sol', 'S/'),
      ('PGK', 'Papua New Guinean Kina', 'K'),
      ('PHP', 'Philippine Peso', '₱'),
      ('PKR', 'Pakistani Rupee', '₨'),
      ('PLN', 'Polish Złoty', 'zł'),
      ('PYG', 'Paraguayan Guaraní', '₲'),
      ('QAR', 'Qatari Riyal', 'ر.ق'),
      ('RON', 'Romanian Leu', 'lei'),
      ('RSD', 'Serbian Dinar', 'дин'),
      ('RUB', 'Russian Ruble', '₽'),
      ('RWF', 'Rwandan Franc', 'FRw'),
      ('SAR', 'Saudi Riyal', 'ر.س'),
      ('SBD', 'Solomon Islands Dollar', 'SI\$'),
      ('SCR', 'Seychellois Rupee', '₨'),
      ('SDG', 'Sudanese Pound', 'ج.س.'),
      ('SEK', 'Swedish Krona', 'kr'),
      ('SGD', 'Singapore Dollar', 'S\$'),
      ('SHP', 'Saint Helena Pound', '£'),
      ('SLL', 'Sierra Leonean Leone', 'Le'),
      ('SOS', 'Somali Shilling', 'Sh'),
      ('SRD', 'Surinamese Dollar', '\$'),
      ('SSP', 'South Sudanese Pound', '£'),
      ('STN', 'São Tomé and Príncipe Dobra', 'Db'),
      ('SYP', 'Syrian Pound', '£'),
      ('SZL', 'Eswatini Lilangeni', 'L'),
      ('THB', 'Thai Baht', '฿'),
      ('TJS', 'Tajikistani Somoni', 'ЅМ'),
      ('TMT', 'Turkmenistani Manat', 'm'),
      ('TND', 'Tunisian Dinar', 'د.ت'),
      ('TOP', 'Tongan Paʻanga', 'T\$'),
      ('TRY', 'Turkish Lira', '₺'),
      ('TTD', 'Trinidad and Tobago Dollar', 'TT\$'),
      ('TVD', 'Tuvaluan Dollar', '\$'),
      ('TZS', 'Tanzanian Shilling', 'TSh'),
      ('UAH', 'Ukrainian Hryvnia', '₴'),
      ('UGX', 'Ugandan Shilling', 'USh'),
      ('USD', 'US Dollar', '\$'),
      ('UYU', 'Uruguayan Peso', '\$U'),
      ('UZS', 'Uzbekistani Soʻm', 'soʻm'),
      ('VES', 'Venezuelan Bolívar', 'Bs.'),
      ('VND', 'Vietnamese Đồng', '₫'),
      ('VUV', 'Vanuatu Vatu', 'Vt'),
      ('WST', 'Samoan Tālā', 'WS\$'),
      ('XAF', 'Central African CFA Franc', 'FCFA'),
      ('XCD', 'East Caribbean Dollar', 'EC\$'),
      ('XOF', 'West African CFA Franc', 'CFA'),
      ('XPF', 'CFP Franc', '₣'),
      ('YER', 'Yemeni Rial', '﷼'),
      ('ZAR', 'South African Rand', 'R'),
      ('ZMW', 'Zambian Kwacha', 'ZK'),
      ('ZWL', 'Zimbabwean Dollar', 'Z\$');
    ''');
  }

  // Insert Transaction
  Future<int> insertTransaction(Map<String, dynamic> transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction);
  }

  // Fetch Categories by Type
  Future<List<Map<String, dynamic>>> getCategoriesByType(String type) async {
    final db = await database;

    // Map "Expense" to "spending" and ensure correct query
    final dbType = (type == 'expense') ? 'spending' : type;

    return await db.rawQuery('''
    SELECT * FROM categories
    WHERE type = ? OR type = "both";
  ''', [dbType]);
  }

  // Fetch All Transactions with Category Icons
  Future<List<Map<String, dynamic>>> getTransactionsWithIcons() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT t.*, c.icon_name
      FROM transactions t
      INNER JOIN categories c ON t.category = c.id
    ''');
  }

  Future<List<Map<String, dynamic>>> getTransactionsOrderedByDate() async {
    final db = await database;

    // Join transactions with categories to get the category name and icon_name
    return await db.rawQuery('''
    SELECT t.id, t.title, t.amount, t.date, t.type, c.category AS category, c.icon_name AS icon_name
    FROM transactions t
    INNER JOIN categories c ON t.category = c.id
    ORDER BY t.date DESC
  ''');
  }

  //Insert or Update Overall Budget
  Future<void> saveOverallBudget(double amount) async {
    final db = await database;

    await db.insert(
      'budgets',
      {'type': 'overall', 'category_id': null, 'amount': amount},
      conflictAlgorithm: ConflictAlgorithm.replace, // Update if budget exists
    );
  }

  //Insert or Update Category Budget
  Future<void> saveCategoryBudget(int categoryId, double amount) async {
    final db = await database;

    await db.insert(
      'budgets',
      {'type': 'category', 'category_id': categoryId, 'amount': amount},
      conflictAlgorithm: ConflictAlgorithm.replace, // Update if budget exists
    );
  }

  // Fetch Overall Budget
  Future<List<Map<String, dynamic>>> getOverallBudget() async {
    final db = await database;

    return await db.query(
      'budgets',
      where: 'type = ?',
      whereArgs: ['overall'],
    );
  }

  // Fetch Category Budgets
  Future<List<Map<String, dynamic>>> getSpendingCategoriesWithBudgets() async {
    final db = await database;

    return await db.rawQuery('''
    SELECT b.amount, c.category, c.icon_name 
    FROM budgets b 
    INNER JOIN categories c ON b.category_id = c.id 
    WHERE b.type = "category"
  ''');
  }

  // Fetch total budget for the current month
  Future<double> getTotalBudget() async {
    final db = await database;

    // Use rawQuery for custom SQL queries
    final result = await db.rawQuery(
      '''
    SELECT amount as total_budget 
    FROM budgets 
    WHERE type = ?
    ''',
      ['overall'], // Pass the whereArgs here
    );

    // If result is empty, return 0.0
    if (result.isEmpty) return 0.0;

    // Cast the retrieved amount to double safely

    return result.first['total_budget'] as double? ?? 0.0;
  }

  // Fetch total expenses for the current month
  Future<double> getTotalExpensesForCurrentMonth() async {
    final db = await database;
    final now = DateTime.now();

    final result = await db.rawQuery('''
    SELECT SUM(amount) as total_expenses 
    FROM transactions 
    WHERE type = 'expense'
      AND strftime('%m', date) = ? 
      AND strftime('%Y', date) = ?
  ''', [
      now.month.toString().padLeft(2, '0'), // Format month as two digits
      now.year.toString(),
    ]);

    // Return the total_expenses or 0.0 if no expenses found
    return result.first['total_expenses'] as double? ?? 0.0;
  }

  Future<void> debugCategories() async {
    final dbHelper = DatabaseHelper();
    final categories =
        await dbHelper.database.then((db) => db.query('categories'));
    print("Categories from database: $categories");
  }

  Future<void> debugTransactions() async {
    final dbHelper = DatabaseHelper();
    final transactions =
        await dbHelper.database.then((db) => db.query('transactions'));
    print("Transactions from database: $transactions");
  }
}

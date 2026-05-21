import '../models/ecommerce_models.dart';

class MockDatabase {
  MockDatabase._();

  // --- CURRENT USER STATE ---
  static bool isAuthenticated = false;
  static String userPhone = '';
  static double walletCashback = 250.0;
  static double walletPoints = 1200.0;
  static double walletReferralCredits = 100.0;

  // --- REVIEWS DATA ---
  static final List<Review> _mockReviews = [
    Review(
      id: 'rev1',
      username: 'David K.',
      rating: 4.8,
      comment: 'Excellent fit and premium fabric. Feels very high-end and breathable. Perfect for daily wear.',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Review(
      id: 'rev2',
      username: 'Sarah M.',
      rating: 4.5,
      comment: 'Exactly as shown in the images. The gold stitching looks exquisite. Fit is true to size.',
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    Review(
      id: 'rev3',
      username: 'Elena R.',
      rating: 5.0,
      comment: 'Super fast delivery (got it in 24 hours). The packaging was amazing. Solid 5 stars!',
      date: DateTime.now().subtract(const Duration(days: 12)),
    ),
  ];

  // --- CATEGORIES ---
  static final List<Category> categories = [
    const Category(
      id: 'cat1',
      name: 'Mobiles',
      imageUrl: 'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=300&q=80',
    ),
    const Category(
      id: 'cat2',
      name: 'Shoes',
      imageUrl: 'https://images.unsplash.com/photo-1533867617858-e7b97e060509?auto=format&fit=crop&w=300&q=80',
    ),
    const Category(
      id: 'cat3',
      name: 'Accessories',
      imageUrl: 'https://images.unsplash.com/photo-1627124765135-56673fc4f99b?auto=format&fit=crop&w=300&q=80',
    ),
  ];

  // --- PRODUCTS INVENTORY ---
  static final List<Product> products = [
    Product(
      id: 'prod1',
      name: 'HMD Crest Max 5G',
      description: 'Premium glass back meets outstanding performance. Featuring a 50MP triple AI camera, gorgeous matte finish back glass, and a vivid 90Hz AMOLED display for premium visual clarity and modern elegance.',
      price: 14999.0,
      originalPrice: 16999.0,
      categoryId: 'cat1',
      imageUrls: const [
        'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=800&q=80',
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
      ],
      availableSizes: const ['8GB + 256GB'],
      availableColors: const ['Royal Purple', 'Matte Black', 'Emerald Green'],
      averageRating: 4.8,
      totalReviews: 48,
      reviews: _mockReviews,
      isFeatured: true,
      isTrending: true,
      isNewArrival: true,
      stockCount: 15,
    ),
    Product(
      id: 'prod2',
      name: 'HMD Crest 5G',
      description: 'Crafted for clarity and speed. Featuring a stunning 50MP Selfie Camera, 50MP dual rear camera setup, and 6GB RAM + 128GB internal storage for seamless multitasking and daily gaming.',
      price: 12999.0,
      originalPrice: 14499.0,
      categoryId: 'cat1',
      imageUrls: const [
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=800&q=80',
      ],
      availableSizes: const ['6GB + 128GB'],
      availableColors: const ['Lush Peach', 'Midnight Blue'],
      averageRating: 4.7,
      totalReviews: 24,
      reviews: _mockReviews.sublist(0, 2),
      isFeatured: true,
      isTrending: false,
      isNewArrival: true,
      stockCount: 12,
    ),
    Product(
      id: 'prod3',
      name: 'HMD Pulse Pro 4G',
      description: 'Sleek, repairable, and durable. The Pulse Pro offers clean Nordic design with easy self-repairability, an epic 3-day battery life, and smooth octa-core performance for everyday efficiency.',
      price: 9999.0,
      originalPrice: 11999.0,
      categoryId: 'cat1',
      imageUrls: const [
        'https://images.unsplash.com/photo-1565849906660-7ea469f66870?auto=format&fit=crop&w=800&q=80',
      ],
      availableSizes: const ['6GB + 128GB'],
      availableColors: const ['Glacier Green', 'Black Coal'],
      averageRating: 4.5,
      totalReviews: 32,
      reviews: _mockReviews.sublist(1, 3),
      isFeatured: false,
      isTrending: true,
      isNewArrival: false,
      stockCount: 20,
    ),
    Product(
      id: 'prod4',
      name: 'HMD 105 Classic',
      description: 'Built to last. The HMD 105 classic keypad phone features built-in UPI payment support, a dual LED torch, wireless FM radio, and the legendary durable shell for seamless communications.',
      price: 1199.0,
      categoryId: 'cat1',
      imageUrls: const [
        'https://images.unsplash.com/photo-1523206489230-c012c64b2b48?auto=format&fit=crop&w=800&q=80',
      ],
      availableSizes: const ['Standard'],
      availableColors: const ['Charcoal Black', 'Ocean Blue'],
      averageRating: 4.3,
      totalReviews: 120,
      reviews: _mockReviews.sublist(1, 3),
      isFeatured: false,
      isTrending: true,
      isNewArrival: false,
      stockCount: 50,
    ),
    Product(
      id: 'prod5',
      name: 'HMD 110 Keypad',
      description: 'Simple yet feature-packed keypad phone. Features a built-in rear camera, UPI payment verification, MP3 music player support, and premium curved ergonomics.',
      price: 1699.0,
      originalPrice: 1999.0,
      categoryId: 'cat1',
      imageUrls: const [
        'https://images.unsplash.com/photo-1573148195900-7845dcb9b127?auto=format&fit=crop&w=800&q=80',
      ],
      availableSizes: const ['Standard'],
      availableColors: const ['Mint Green', 'Midnight Black'],
      averageRating: 4.4,
      totalReviews: 18,
      reviews: _mockReviews.sublist(0, 1),
      isFeatured: false,
      isTrending: false,
      isNewArrival: true,
      stockCount: 25,
    ),
    Product(
      id: 'prod6',
      name: 'Sreeleathers Oxford Formal',
      description: 'The hallmark of corporate elegance. Handcrafted from genuine top-grain leather, featuring a sleek lace-up profile and memory foam cushioning for full-day office comfort.',
      price: 1499.0,
      originalPrice: 1999.0,
      categoryId: 'cat2',
      imageUrls: const [
        'https://images.unsplash.com/photo-1533867617858-e7b97e060509?auto=format&fit=crop&w=800&q=80',
      ],
      availableSizes: const ['UK 7', 'UK 8', 'UK 9', 'UK 10'],
      availableColors: const ['Classic Tan', 'Stealth Black'],
      averageRating: 4.6,
      totalReviews: 45,
      reviews: _mockReviews,
      isFeatured: true,
      isTrending: true,
      isNewArrival: true,
      stockCount: 15,
    ),
    Product(
      id: 'prod7',
      name: 'Sreeleathers Leather Loafers',
      description: 'Effortless style for casual and semi-formal wear. Slip-on design with elasticated side panels and hand-stitched premium leather detailing.',
      price: 999.0,
      originalPrice: 1299.0,
      categoryId: 'cat2',
      imageUrls: const [
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?auto=format&fit=crop&w=800&q=80',
      ],
      availableSizes: const ['UK 7', 'UK 8', 'UK 9', 'UK 10'],
      availableColors: const ['Rich Mahogany', 'Deep Navy'],
      averageRating: 4.5,
      totalReviews: 29,
      reviews: _mockReviews.sublist(0, 2),
      isFeatured: true,
      isTrending: true,
      isNewArrival: false,
      stockCount: 18,
    ),
    Product(
      id: 'prod8',
      name: 'Sreeleathers Chukka Boots',
      description: 'Rugged durability meets refined design. Ankle-high genuine suede leather chukka boots with slip-resistant TPR rubber outsoles and custom eyelets.',
      price: 2199.0,
      originalPrice: 2999.0,
      categoryId: 'cat2',
      imageUrls: const [
        'https://images.unsplash.com/photo-1608256246200-53e635b5b65f?auto=format&fit=crop&w=800&q=80',
      ],
      availableSizes: const ['UK 8', 'UK 9', 'UK 10'],
      availableColors: const ['Suede Tan', 'Carbon Black'],
      averageRating: 4.7,
      totalReviews: 38,
      reviews: _mockReviews.sublist(1, 3),
      isFeatured: true,
      isTrending: false,
      isNewArrival: true,
      stockCount: 8,
    ),
    Product(
      id: 'prod9',
      name: 'Sreeleathers Breathable Sandals',
      description: 'Premium leather cross-strap sandals, featuring dual-density orthotic footbeds and adjustable brass buckle enclosures.',
      price: 899.0,
      originalPrice: 1099.0,
      categoryId: 'cat2',
      imageUrls: const [
        'https://images.unsplash.com/photo-1603252109303-2751441dd157?auto=format&fit=crop&w=800&q=80',
      ],
      availableSizes: const ['UK 7', 'UK 8', 'UK 9'],
      availableColors: const ['Espresso Brown', 'Soot Black'],
      averageRating: 4.3,
      totalReviews: 50,
      reviews: _mockReviews.sublist(0, 2),
      isFeatured: false,
      isTrending: true,
      isNewArrival: false,
      stockCount: 30,
    ),
    Product(
      id: 'prod10',
      name: 'Sreeleathers Bifold Wallet',
      description: 'Minimalist genuine leather bifold wallet. Detailed with 6 card slots, a secret cash partition, and a quick-access ID window.',
      price: 399.0,
      originalPrice: 599.0,
      categoryId: 'cat3',
      imageUrls: const [
        'https://images.unsplash.com/photo-1627124765135-56673fc4f99b?auto=format&fit=crop&w=800&q=80',
      ],
      availableSizes: const ['Standard'],
      availableColors: const ['Chestnut Brown', 'Jet Black'],
      averageRating: 4.8,
      totalReviews: 88,
      reviews: _mockReviews,
      isFeatured: true,
      isTrending: true,
      isNewArrival: true,
      stockCount: 40,
    ),
    Product(
      id: 'prod11',
      name: 'Sreeleathers Leather Belt',
      description: 'Formal full-grain leather belt with hand-painted burnished edges and a heavy-duty chrome buckle buckle.',
      price: 499.0,
      originalPrice: 699.0,
      categoryId: 'cat3',
      imageUrls: const [
        'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?auto=format&fit=crop&w=800&q=80',
      ],
      availableSizes: const ['32', '34', '36', '38'],
      availableColors: const ['Cognac Brown', 'Onyx Black'],
      averageRating: 4.7,
      totalReviews: 122,
      reviews: _mockReviews.sublist(1, 3),
      isFeatured: true,
      isTrending: false,
      isNewArrival: true,
      stockCount: 35,
    ),
    Product(
      id: 'prod12',
      name: 'Sreeleathers Messenger Bag',
      description: 'Premium genuine leather briefcase laptop messenger bag. Fitted with a padded 15.6-inch laptop pocket, metal zippers, and adjustable shoulder webbing.',
      price: 2499.0,
      originalPrice: 3499.0,
      categoryId: 'cat3',
      imageUrls: const [
        'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?auto=format&fit=crop&w=800&q=80',
      ],
      availableSizes: const ['Standard'],
      availableColors: const ['Vintage Tan', 'Formal Black'],
      averageRating: 4.9,
      totalReviews: 54,
      reviews: _mockReviews,
      isFeatured: true,
      isTrending: true,
      isNewArrival: true,
      stockCount: 10,
    ),
    Product(
      id: 'prod13',
      name: 'Sreeleathers Key & Coin Pouch',
      description: 'A compact leather zip-around pouch designed to hold coins, house keys, and access cards. Includes a sturdy internal keyring clip.',
      price: 199.0,
      originalPrice: 299.0,
      categoryId: 'cat3',
      imageUrls: const [
        'https://images.unsplash.com/photo-1584917865442-de89df76afd3?auto=format&fit=crop&w=800&q=80',
      ],
      availableSizes: const ['Standard'],
      availableColors: const ['Wine Red', 'Forest Green', 'Tan'],
      averageRating: 4.2,
      totalReviews: 14,
      reviews: _mockReviews.sublist(0, 1),
      isFeatured: false,
      isTrending: false,
      isNewArrival: false,
      stockCount: 45,
    ),
  ];

  // --- WISHLIST ---
  static List<Product> wishlist = [];

  // --- USER ADDRESSES ---
  static List<UserAddress> addresses = [
    const UserAddress(
      id: 'addr1',
      fullName: 'Bhawana Chandel',
      phone: '+91 9876543210',
      streetAddress: 'Flat 402, Royal Palms, Sector 56',
      city: 'Gurugram',
      state: 'Haryana',
      postalCode: '122011',
      country: 'India',
      isDefault: true,
    ),
    const UserAddress(
      id: 'addr2',
      fullName: 'Bhawana Chandel (Office)',
      phone: '+91 9876543210',
      streetAddress: 'Tower B, Global Tech Park, DLF Phase 3',
      city: 'Gurugram',
      state: 'Haryana',
      postalCode: '122002',
      country: 'India',
      isDefault: false,
    ),
  ];

  // --- WALLET TRANSACTIONS HISTORY ---
  static List<WalletTransaction> walletTransactions = [
    WalletTransaction(
      id: 'tx1',
      description: 'Cashback received for Order #IR-20412',
      amount: 150.0,
      timestamp: DateTime.now().subtract(const Duration(days: 3)),
      isCredit: true,
    ),
    WalletTransaction(
      id: 'tx2',
      description: 'Referral credit (Invited Rahul S.)',
      amount: 100.0,
      timestamp: DateTime.now().subtract(const Duration(days: 7)),
      isCredit: true,
    ),
    WalletTransaction(
      id: 'tx3',
      description: 'Wallet debit for Order #IR-18290',
      amount: 50.0,
      timestamp: DateTime.now().subtract(const Duration(days: 15)),
      isCredit: false,
    ),
  ];

  // --- ACTIVE CART LIST ---
  static List<CartItem> cart = [];

  // --- USER ORDERS ---
  static List<Order> orders = [
    Order(
      id: 'IR-20412',
      items: [
        CartItem(
          id: 'ci_past1',
          product: products[2], // Tshirt
          quantity: 2,
          selectedColor: 'Sage Green',
          selectedSize: 'L',
        ),
      ],
      totalAmount: 4998.0,
      discountAmount: 0.0,
      walletDeduction: 0.0,
      paidAmount: 4998.0,
      deliveryAddress: addresses[0],
      status: OrderStatus.delivered,
      orderDate: DateTime.now().subtract(const Duration(days: 3)),
      paymentMethod: 'UPI',
      trackingId: 'TRK-9831048-A',
    ),
  ];

  // --- PROMO CODES ---
  static final Map<String, double> promoCodes = {
    'LUXE10': 0.10, // 10% Off
    'FIRSTBUY': 500.0, // Rs 500 Flat Off
    'FESTIVE20': 0.20, // 20% Off
  };
}

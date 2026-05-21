import 'package:equatable/equatable.dart';

// --- USER ADDRESS MODEL ---
class UserAddress extends Equatable {
  final String id;
  final String fullName;
  final String phone;
  final String streetAddress;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final bool isDefault;

  const UserAddress({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.isDefault = false,
  });

  @override
  List<Object?> get props => [id, fullName, phone, streetAddress, city, state, postalCode, country, isDefault];
}

// --- REVIEW MODEL ---
class Review extends Equatable {
  final String id;
  final String username;
  final double rating;
  final String comment;
  final DateTime date;

  const Review({
    required this.id,
    required this.username,
    required this.rating,
    required this.comment,
    required this.date,
  });

  @override
  List<Object?> get props => [id, username, rating, comment, date];
}

// --- PRODUCT CATEGORY MODEL ---
class Category extends Equatable {
  final String id;
  final String name;
  final String imageUrl;

  const Category({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, imageUrl];
}

// --- PRODUCT MODEL ---
class Product extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice; // For discounts
  final String categoryId;
  final List<String> imageUrls;
  final List<String> availableSizes;
  final List<String> availableColors;
  final double averageRating;
  final int totalReviews;
  final List<Review> reviews;
  final bool isFeatured;
  final bool isTrending;
  final bool isNewArrival;
  final bool isLimitedEdition;
  final int stockCount;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.categoryId,
    required this.imageUrls,
    required this.availableSizes,
    required this.availableColors,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.reviews = const [],
    this.isFeatured = false,
    this.isTrending = false,
    this.isNewArrival = false,
    this.isLimitedEdition = false,
    this.stockCount = 10,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
  int get discountPercentage => hasDiscount ? (((originalPrice! - price) / originalPrice!) * 100).round() : 0;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        originalPrice,
        categoryId,
        imageUrls,
        availableSizes,
        availableColors,
        averageRating,
        totalReviews,
        reviews,
        isFeatured,
        isTrending,
        isNewArrival,
        isLimitedEdition,
        stockCount,
      ];
}

// --- CART ITEM MODEL ---
class CartItem extends Equatable {
  final String id;
  final Product product;
  final int quantity;
  final String selectedSize;
  final String selectedColor;

  const CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
    required this.selectedSize,
    required this.selectedColor,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    int? quantity,
    String? selectedSize,
    String? selectedColor,
  }) {
    return CartItem(
      id: id,
      product: product,
      quantity: quantity ?? this.quantity,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }

  @override
  List<Object?> get props => [id, product, quantity, selectedSize, selectedColor];
}

// --- WALLET TRANSACTION ---
class WalletTransaction extends Equatable {
  final String id;
  final String description;
  final double amount;
  final DateTime timestamp;
  final bool isCredit; // true = cashback/referral credited, false = debited for purchase

  const WalletTransaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.timestamp,
    required this.isCredit,
  });

  @override
  List<Object?> get props => [id, description, amount, timestamp, isCredit];
}

// --- ORDER STATUS ENUM ---
enum OrderStatus { preparing, packed, shipped, outForDelivery, delivered }

// --- ORDER MODEL ---
class Order extends Equatable {
  final String id;
  final List<CartItem> items;
  final double totalAmount;
  final double discountAmount;
  final double walletDeduction;
  final double paidAmount;
  final UserAddress deliveryAddress;
  final OrderStatus status;
  final DateTime orderDate;
  final String paymentMethod;
  final String trackingId;

  const Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.discountAmount,
    required this.walletDeduction,
    required this.paidAmount,
    required this.deliveryAddress,
    required this.status,
    required this.orderDate,
    required this.paymentMethod,
    required this.trackingId,
  });

  @override
  List<Object?> get props => [
        id,
        items,
        totalAmount,
        discountAmount,
        walletDeduction,
        paidAmount,
        deliveryAddress,
        status,
        orderDate,
        paymentMethod,
        trackingId,
      ];
}

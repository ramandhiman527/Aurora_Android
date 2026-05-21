import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/models/ecommerce_models.dart';
import '../../../../core/data/mock_database.dart';

// --- ORDER EVENTS ---
abstract class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object?> get props => [];
}

class LoadOrdersEvent extends OrderEvent {}

class PlaceOrderEvent extends OrderEvent {
  final List<CartItem> items;
  final double totalAmount;
  final double discountAmount;
  final double walletDeduction;
  final double paidAmount;
  final UserAddress deliveryAddress;
  final String paymentMethod;

  const PlaceOrderEvent({
    required this.items,
    required this.totalAmount,
    required this.discountAmount,
    required this.walletDeduction,
    required this.paidAmount,
    required this.deliveryAddress,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [items, totalAmount, discountAmount, walletDeduction, paidAmount, deliveryAddress, paymentMethod];
}

class AdminUpdateOrderStatusEvent extends OrderEvent {
  final String orderId;
  final OrderStatus newStatus;

  const AdminUpdateOrderStatusEvent(this.orderId, this.newStatus);
  @override
  List<Object?> get props => [orderId, newStatus];
}

class AdminAddProductEvent extends OrderEvent {
  final Product product;
  const AdminAddProductEvent(this.product);
  @override
  List<Object?> get props => [product];
}

class AdminDeleteProductEvent extends OrderEvent {
  final String productId;
  const AdminDeleteProductEvent(this.productId);
  @override
  List<Object?> get props => [productId];
}

class AdminUpdateStockEvent extends OrderEvent {
  final String productId;
  final int newStock;
  const AdminUpdateStockEvent(this.productId, this.newStock);
  @override
  List<Object?> get props => [productId, newStock];
}

// --- ORDER STATES ---
abstract class OrderState extends Equatable {
  const OrderState();
  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccessState extends OrderState {
  final Order order;
  const OrderSuccessState(this.order);
  @override
  List<Object?> get props => [order];
}

class OrdersLoadedState extends OrderState {
  final List<Order> orders;
  final List<Product> adminProducts; // For inventory management
  final String? successMessage;

  const OrdersLoadedState({
    required this.orders,
    required this.adminProducts,
    this.successMessage,
  });

  OrdersLoadedState copyWith({
    List<Order>? orders,
    List<Product>? adminProducts,
    String? successMessage,
  }) {
    return OrdersLoadedState(
      orders: orders ?? this.orders,
      adminProducts: adminProducts ?? this.adminProducts,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props => [orders, adminProducts, successMessage];
}

class OrderError extends OrderState {
  final String message;
  const OrderError(this.message);
  @override
  List<Object?> get props => [message];
}

// --- ORDER BLOC ---
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<LoadOrdersEvent>((event, emit) async {
      emit(OrderLoading());
      await Future.delayed(const Duration(milliseconds: 400));
      emit(OrdersLoadedState(
        orders: List.from(MockDatabase.orders.reversed),
        adminProducts: List.from(MockDatabase.products),
      ));
    });

    on<PlaceOrderEvent>((event, emit) async {
      emit(OrderLoading());
      await Future.delayed(const Duration(milliseconds: 1500)); // Simulate gateway

      // Create new Order
      final orderId = 'IR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
      final newOrder = Order(
        id: orderId,
        items: List.from(event.items),
        totalAmount: event.totalAmount,
        discountAmount: event.discountAmount,
        walletDeduction: event.walletDeduction,
        paidAmount: event.paidAmount,
        deliveryAddress: event.deliveryAddress,
        status: OrderStatus.preparing,
        orderDate: DateTime.now(),
        paymentMethod: event.paymentMethod,
        trackingId: 'TRK-${DateTime.now().millisecondsSinceEpoch}-A',
      );

      // Save to Mock Database
      MockDatabase.orders.add(newOrder);

      // Reduce product stock counts
      for (var item in event.items) {
        final productIndex = MockDatabase.products.indexWhere((p) => p.id == item.product.id);
        if (productIndex != -1) {
          final prod = MockDatabase.products[productIndex];
          int newStock = prod.stockCount - item.quantity;
          if (newStock < 0) newStock = 0;
          MockDatabase.products[productIndex] = Product(
            id: prod.id,
            name: prod.name,
            description: prod.description,
            price: prod.price,
            originalPrice: prod.originalPrice,
            categoryId: prod.categoryId,
            imageUrls: prod.imageUrls,
            availableSizes: prod.availableSizes,
            availableColors: prod.availableColors,
            averageRating: prod.averageRating,
            totalReviews: prod.totalReviews,
            reviews: prod.reviews,
            isFeatured: prod.isFeatured,
            isTrending: prod.isTrending,
            isNewArrival: prod.isNewArrival,
            isLimitedEdition: prod.isLimitedEdition,
            stockCount: newStock,
          );
        }
      }

      // Handle Wallet Cashback deduction if used
      if (event.walletDeduction > 0) {
        MockDatabase.walletCashback -= event.walletDeduction;
        final walletTx = WalletTransaction(
          id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
          description: 'Used cashback for Order #$orderId',
          amount: event.walletDeduction,
          timestamp: DateTime.now(),
          isCredit: false,
        );
        MockDatabase.walletTransactions.add(walletTx);
      }

      // Add cashback reward for purchase (10% of paid amount up to Rs 200)
      double rewardsEarned = (event.paidAmount * 0.10);
      if (rewardsEarned > 200) rewardsEarned = 200;
      rewardsEarned = double.parse(rewardsEarned.toStringAsFixed(1));
      
      if (rewardsEarned > 0) {
        MockDatabase.walletCashback += rewardsEarned;
        final rewardTx = WalletTransaction(
          id: 'tx_r_${DateTime.now().millisecondsSinceEpoch}',
          description: 'Cashback reward earned for Order #$orderId',
          amount: rewardsEarned,
          timestamp: DateTime.now(),
          isCredit: true,
        );
        MockDatabase.walletTransactions.add(rewardTx);
      }

      emit(OrderSuccessState(newOrder));
    });

    on<AdminUpdateOrderStatusEvent>((event, emit) async {
      if (state is OrdersLoadedState) {
        final currentState = state as OrdersLoadedState;
        
        final orderIndex = MockDatabase.orders.indexWhere((o) => o.id == event.orderId);
        if (orderIndex != -1) {
          final o = MockDatabase.orders[orderIndex];
          MockDatabase.orders[orderIndex] = Order(
            id: o.id,
            items: o.items,
            totalAmount: o.totalAmount,
            discountAmount: o.discountAmount,
            walletDeduction: o.walletDeduction,
            paidAmount: o.paidAmount,
            deliveryAddress: o.deliveryAddress,
            status: event.newStatus,
            orderDate: o.orderDate,
            paymentMethod: o.paymentMethod,
            trackingId: o.trackingId,
          );
        }
        
        emit(OrdersLoadedState(
          orders: List.from(MockDatabase.orders.reversed),
          adminProducts: List.from(MockDatabase.products),
          successMessage: 'Order status updated successfully',
        ));
      }
    });

    on<AdminAddProductEvent>((event, emit) async {
      if (state is OrdersLoadedState) {
        MockDatabase.products.add(event.product);
        emit(OrdersLoadedState(
          orders: List.from(MockDatabase.orders.reversed),
          adminProducts: List.from(MockDatabase.products),
          successMessage: 'Product added to catalog',
        ));
      }
    });

    on<AdminDeleteProductEvent>((event, emit) async {
      if (state is OrdersLoadedState) {
        MockDatabase.products.removeWhere((p) => p.id == event.productId);
        emit(OrdersLoadedState(
          orders: List.from(MockDatabase.orders.reversed),
          adminProducts: List.from(MockDatabase.products),
          successMessage: 'Product removed from catalog',
        ));
      }
    });

    on<AdminUpdateStockEvent>((event, emit) async {
      if (state is OrdersLoadedState) {
        final index = MockDatabase.products.indexWhere((p) => p.id == event.productId);
        if (index != -1) {
          final prod = MockDatabase.products[index];
          MockDatabase.products[index] = Product(
            id: prod.id,
            name: prod.name,
            description: prod.description,
            price: prod.price,
            originalPrice: prod.originalPrice,
            categoryId: prod.categoryId,
            imageUrls: prod.imageUrls,
            availableSizes: prod.availableSizes,
            availableColors: prod.availableColors,
            averageRating: prod.averageRating,
            totalReviews: prod.totalReviews,
            reviews: prod.reviews,
            isFeatured: prod.isFeatured,
            isTrending: prod.isTrending,
            isNewArrival: prod.isNewArrival,
            isLimitedEdition: prod.isLimitedEdition,
            stockCount: event.newStock,
          );
        }
        
        emit(OrdersLoadedState(
          orders: List.from(MockDatabase.orders.reversed),
          adminProducts: List.from(MockDatabase.products),
          successMessage: 'Stock count updated',
        ));
      }
    });
  }
}

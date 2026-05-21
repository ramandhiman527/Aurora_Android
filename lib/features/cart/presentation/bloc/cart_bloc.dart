import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/models/ecommerce_models.dart';
import '../../../../core/data/mock_database.dart';

// --- CART EVENTS ---
abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class LoadCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final Product product;
  final String size;
  final String color;
  final int quantity;

  const AddToCartEvent({
    required this.product,
    required this.size,
    required this.color,
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [product, size, color, quantity];
}

class RemoveFromCartEvent extends CartEvent {
  final String cartItemId;
  const RemoveFromCartEvent(this.cartItemId);
  @override
  List<Object?> get props => [cartItemId];
}

class UpdateQuantityEvent extends CartEvent {
  final String cartItemId;
  final int newQuantity;

  const UpdateQuantityEvent(this.cartItemId, this.newQuantity);
  @override
  List<Object?> get props => [cartItemId, newQuantity];
}

class ApplyPromoCodeEvent extends CartEvent {
  final String code;
  const ApplyPromoCodeEvent(this.code);
  @override
  List<Object?> get props => [code];
}

class RemovePromoCodeEvent extends CartEvent {}

class ToggleWalletDeductionEvent extends CartEvent {
  final bool useWallet;
  const ToggleWalletDeductionEvent(this.useWallet);
  @override
  List<Object?> get props => [useWallet];
}

class ClearCartEvent extends CartEvent {}

// --- CART STATES ---
abstract class CartState extends Equatable {
  const CartState();
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoadedState extends CartState {
  final List<CartItem> items;
  final double subtotal;
  final String? appliedPromoCode;
  final double discount;
  final bool useWallet;
  final double walletDeduction;
  final double total;
  final String? message;

  const CartLoadedState({
    required this.items,
    required this.subtotal,
    this.appliedPromoCode,
    required this.discount,
    required this.useWallet,
    required this.walletDeduction,
    required this.total,
    this.message,
  });

  CartLoadedState copyWith({
    List<CartItem>? items,
    double? subtotal,
    String? appliedPromoCode,
    double? discount,
    bool? useWallet,
    double? walletDeduction,
    double? total,
    String? message,
  }) {
    return CartLoadedState(
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      appliedPromoCode: appliedPromoCode ?? this.appliedPromoCode,
      discount: discount ?? this.discount,
      useWallet: useWallet ?? this.useWallet,
      walletDeduction: walletDeduction ?? this.walletDeduction,
      total: total ?? this.total,
      message: message,
    );
  }

  @override
  List<Object?> get props => [items, subtotal, appliedPromoCode, discount, useWallet, walletDeduction, total, message];
}

class CartError extends CartState {
  final String message;
  const CartError(this.message);
  @override
  List<Object?> get props => [message];
}

// --- CART BLOC ---
class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<LoadCartEvent>((event, emit) {
      emit(CartLoading());
      _recalculateAndEmit(emit);
    });

    on<AddToCartEvent>((event, emit) async {
      emit(CartLoading());
      await Future.delayed(const Duration(milliseconds: 300));
      
      final existingIndex = MockDatabase.cart.indexWhere((item) =>
          item.product.id == event.product.id &&
          item.selectedSize == event.size &&
          item.selectedColor == event.color);

      if (existingIndex != -1) {
        final currentItem = MockDatabase.cart[existingIndex];
        MockDatabase.cart[existingIndex] = currentItem.copyWith(
          quantity: currentItem.quantity + event.quantity,
        );
      } else {
        final newItem = CartItem(
          id: 'ci_${DateTime.now().millisecondsSinceEpoch}',
          product: event.product,
          quantity: event.quantity,
          selectedSize: event.size,
          selectedColor: event.color,
        );
        MockDatabase.cart.add(newItem);
      }

      _recalculateAndEmit(emit, message: 'Added to Bag successfully');
    });

    on<RemoveFromCartEvent>((event, emit) {
      MockDatabase.cart.removeWhere((item) => item.id == event.cartItemId);
      _recalculateAndEmit(emit, message: 'Removed from Bag');
    });

    on<UpdateQuantityEvent>((event, emit) {
      final index = MockDatabase.cart.indexWhere((item) => item.id == event.cartItemId);
      if (index != -1) {
        if (event.newQuantity <= 0) {
          MockDatabase.cart.removeAt(index);
        } else {
          MockDatabase.cart[index] = MockDatabase.cart[index].copyWith(quantity: event.newQuantity);
        }
      }
      _recalculateAndEmit(emit);
    });

    on<ApplyPromoCodeEvent>((event, emit) {
      final code = event.code.toUpperCase();
      if (MockDatabase.promoCodes.containsKey(code)) {
        _recalculateAndEmit(emit, appliedPromo: code, message: 'Coupon code "$code" applied successfully');
      } else {
        _recalculateAndEmit(emit, message: 'Invalid promo code');
      }
    });

    on<RemovePromoCodeEvent>((event, emit) {
      _recalculateAndEmit(emit, removePromo: true, message: 'Promo code removed');
    });

    on<ToggleWalletDeductionEvent>((event, emit) {
      _recalculateAndEmit(emit, toggleWallet: event.useWallet);
    });

    on<ClearCartEvent>((event, emit) {
      MockDatabase.cart.clear();
      emit(const CartLoadedState(
        items: [],
        subtotal: 0,
        discount: 0,
        useWallet: false,
        walletDeduction: 0,
        total: 0,
      ));
    });
  }

  void _recalculateAndEmit(
    Emitter<CartState> emit, {
    String? appliedPromo,
    bool removePromo = false,
    bool? toggleWallet,
    String? message,
  }) {
    final items = List<CartItem>.from(MockDatabase.cart);
    double subtotal = 0;
    for (var item in items) {
      subtotal += item.totalPrice;
    }

    // Handle Promo Code Inherited from current state
    String? currentPromo;
    bool useWallet = false;

    if (state is CartLoadedState) {
      final oldState = state as CartLoadedState;
      currentPromo = oldState.appliedPromoCode;
      useWallet = oldState.useWallet;
    }

    if (appliedPromo != null) currentPromo = appliedPromo;
    if (removePromo) currentPromo = null;
    if (toggleWallet != null) useWallet = toggleWallet;

    // Calculate Promo Discount
    double discount = 0;
    if (currentPromo != null) {
      final discountVal = MockDatabase.promoCodes[currentPromo]!;
      if (discountVal < 1.0) {
        discount = subtotal * discountVal;
      } else {
        discount = discountVal; // flat reduction
      }
    }

    if (discount > subtotal) discount = subtotal;

    // Calculate Wallet Deduction
    double walletDeduction = 0;
    final balance = MockDatabase.walletCashback;
    final remainingAmount = subtotal - discount;

    if (useWallet && remainingAmount > 0) {
      if (balance >= remainingAmount) {
        walletDeduction = remainingAmount;
      } else {
        walletDeduction = balance;
      }
    }

    double total = subtotal - discount - walletDeduction;
    if (total < 0) total = 0;

    emit(CartLoadedState(
      items: items,
      subtotal: subtotal,
      appliedPromoCode: currentPromo,
      discount: discount,
      useWallet: useWallet,
      walletDeduction: walletDeduction,
      total: total,
      message: message,
    ));
  }
}

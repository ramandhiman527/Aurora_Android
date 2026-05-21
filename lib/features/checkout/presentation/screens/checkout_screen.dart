import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/data/mock_database.dart';
import '../../../../core/models/ecommerce_models.dart';
import '../../../../core/theme/colors.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _selectedAddressIndex = 0;
  String _selectedPaymentMethod = 'UPI'; // 'UPI', 'CARD', 'COD'
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Dispatch order bloc load to verify items
    context.read<OrderBloc>().add(LoadOrdersEvent());
  }

  void _triggerPaymentFlow(BuildContext context, CartLoadedState cartState) async {
    setState(() {
      _isProcessing = true;
    });

    // Simulate Razorpay payment gateway screen loading
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    // Show Razorpay UI overlay simulation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'RAZORPAY SECURE',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.0, color: Colors.blue),
                  ),
                  Image.network(
                    'https://razorpay.com/assets/razorpay-logo.svg', // will fail gracefully or show placeholder
                    width: 60,
                    errorBuilder: (_, __, ___) => const Text('RazorpPay', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                'Payable Amount: ₹${cartState.total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Simulating payment gateway authorization...',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.blue)),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogCtx);
                      setState(() {
                        _isProcessing = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Payment cancelled by user.'), backgroundColor: AppColors.error),
                      );
                    },
                    child: const Text('CANCEL', style: TextStyle(color: Colors.red)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogCtx);
                      _completeOrder(context, cartState);
                    },
                    child: const Text('AUTHORIZE SUCCESS', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _completeOrder(BuildContext context, CartLoadedState cartState) {
    final selectedAddress = MockDatabase.addresses[_selectedAddressIndex];
    context.read<OrderBloc>().add(PlaceOrderEvent(
          items: cartState.items,
          totalAmount: cartState.subtotal,
          discountAmount: cartState.discount,
          walletDeduction: cartState.walletDeduction,
          paidAmount: cartState.total,
          deliveryAddress: selectedAddress,
          paymentMethod: _selectedPaymentMethod,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CHECKOUT'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          if (cartState is CartLoadedState) {
            return BlocConsumer<OrderBloc, OrderState>(
              listener: (context, orderState) {
                if (orderState is OrderSuccessState) {
                  setState(() {
                    _isProcessing = false;
                  });
                  // Clear checkout state cart
                  context.read<CartBloc>().add(ClearCartEvent());
                  _showSuccessOverlay(context, orderState.order);
                } else if (orderState is OrderError) {
                  setState(() {
                    _isProcessing = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(orderState.message), backgroundColor: AppColors.error),
                  );
                }
              },
              builder: (context, orderState) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Step 1: Address selection
                                _buildAddressSelection(theme, isDark),
                                const Divider(),

                                // Step 2: Payment options
                                _buildPaymentOptions(theme, isDark),
                                const Divider(),

                                // Step 3: Billing recap
                                _buildBillingRecap(cartState, theme, isDark),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                        
                        // Action dock
                        _buildActionDock(cartState, context, isDark),
                      ],
                    ),
                    if (_isProcessing || orderState is OrderLoading)
                      Container(
                        color: Colors.black.withOpacity(0.5),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                );
              },
            );
          }
          return const Center(child: Text('Loading cart details...'));
        },
      ),
    );
  }

  Widget _buildAddressSelection(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DELIVERY ADDRESS',
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.0),
              ),
              Text(
                '+ ADD NEW',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkAccent : AppColors.lightAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: MockDatabase.addresses.length,
            itemBuilder: (context, index) {
              final addr = MockDatabase.addresses[index];
              final isSelected = _selectedAddressIndex == index;

              return GestureDetector(
                onTap: () => setState(() => _selectedAddressIndex = index),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? const Color(0xFF1E1E1E) : const Color(0xFFF0F0F0))
                        : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? (isDark ? AppColors.darkAccent : AppColors.lightPrimary)
                          : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      width: isSelected ? 1.5 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle : Icons.radio_button_off,
                        color: isSelected
                            ? (isDark ? AppColors.darkAccent : AppColors.lightPrimary)
                            : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              addr.fullName,
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${addr.streetAddress}, ${addr.city}, ${addr.state} - ${addr.postalCode}',
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Mobile: ${addr.phone}',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOptions(ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PAYMENT METHOD',
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.0),
          ),
          const SizedBox(height: 14),
          _buildPaymentRow('UPI (GPay / PhonePe / Paytm)', 'UPI', theme, isDark),
          _buildPaymentRow('Credit / Debit Card (Razorpay)', 'CARD', theme, isDark),
          _buildPaymentRow('Cash On Delivery', 'COD', theme, isDark),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, String value, ThemeData theme, bool isDark) {
    final isSelected = _selectedPaymentMethod == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = value),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          border: Border.all(
            color: isSelected
                ? (isDark ? AppColors.darkAccent : AppColors.lightPrimary)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: isSelected ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? (isDark ? AppColors.darkAccent : AppColors.lightPrimary) : Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingRecap(CartLoadedState state, ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ORDER SUMMARY',
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.0),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Items Subtotal', style: theme.textTheme.bodyMedium),
              Text('₹${state.subtotal.toStringAsFixed(0)}', style: theme.textTheme.bodyMedium),
            ],
          ),
          if (state.discount > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Coupon Applied', style: theme.textTheme.bodyMedium),
                Text('- ₹${state.discount.toStringAsFixed(0)}', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.red)),
              ],
            ),
          ],
          if (state.walletDeduction > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Wallet Deducted', style: theme.textTheme.bodyMedium),
                Text('- ₹${state.walletDeduction.toStringAsFixed(0)}', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.amber)),
              ],
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery Fee', style: theme.textTheme.bodyMedium),
              const Text('FREE', style: TextStyle(color: Colors.green)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionDock(CartLoadedState cartState, BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('GRAND TOTAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              Text('₹${cartState.total.toStringAsFixed(0)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(180, 52),
            ),
            onPressed: () {
              if (_selectedPaymentMethod == 'CARD') {
                _triggerPaymentFlow(context, cartState);
              } else {
                _completeOrder(context, cartState);
              }
            },
            child: const Text('PLACE ORDER'),
          ),
        ],
      ),
    );
  }

  void _showSuccessOverlay(BuildContext context, Order order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return WillPopScope(
          onWillPop: () async => false, // Prevent going back
          child: Scaffold(
            backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.green, size: 84),
                    const SizedBox(height: 24),
                    const Text(
                      'ORDER PLACED!',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, letterSpacing: 2.0),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Thank you for shopping with Aura. Your transaction has processed successfully.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Order Reference:', style: TextStyle(fontSize: 12)),
                              Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Paid via:', style: TextStyle(fontSize: 12)),
                              Text(order.paymentMethod, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Delivery Address:', style: TextStyle(fontSize: 12)),
                              Text(order.deliveryAddress.city, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        context.go('/order-tracking/${order.id}');
                      },
                      child: const Text('TRACK ORDER STATUS'),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.go('/');
                      },
                      child: const Text('CONTINUE SHOPPING'),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

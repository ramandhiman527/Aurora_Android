import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/data/mock_database.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/cart_bloc.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _promoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(LoadCartEvent());
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo(BuildContext context) {
    if (_promoController.text.isNotEmpty) {
      context.read<CartBloc>().add(ApplyPromoCodeEvent(_promoController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('SHOPPING BAG'),
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          if (state is CartLoadedState && state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: state.message!.contains('Invalid') ? AppColors.error : AppColors.success,
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoading || state is CartInitial) {
            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
          } else if (state is CartLoadedState) {
            if (state.items.isEmpty) {
              return _buildEmptyCart(theme, isDark);
            }

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // List of items
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.items.length,
                          itemBuilder: (context, index) {
                            final item = state.items[index];
                            return _buildCartItemCard(item, theme, isDark);
                          },
                        ),

                        const SizedBox(height: 16),
                        const Divider(),
                        
                        // Promo code input section
                        _buildPromoSection(state, theme, isDark),
                        
                        const Divider(),

                        // Wallet credit toggle section
                        _buildWalletSection(state, theme, isDark),

                        const Divider(),

                        // Price details breakdown
                        _buildPriceSummary(state, theme, isDark),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Footer checkout bar
                _buildFooterBar(state, context, isDark),
              ],
            );
          } else {
            return const Center(child: Text('Failed to load bag details.'));
          }
        },
      ),
    );
  }

  Widget _buildEmptyCart(ThemeData theme, bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 72,
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
            const SizedBox(height: 20),
            Text(
              'Your Bag is Empty',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Explore trending streetwear, sneakers, and accessories to fill it with custom premium apparel.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go('/discover'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(180, 50),
              ),
              child: const Text('DISCOVER NOW'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemCard(CartItem item, ThemeData theme, bool isDark) {
    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        context.read<CartBloc>().add(RemoveFromCartEvent(item.id));
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: AppColors.error,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.product.imageUrls[0],
                width: 90,
                height: 110,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 15),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _buildBadge('Size: ${item.selectedSize}', theme, isDark),
                      const SizedBox(width: 8),
                      _buildBadge(item.selectedColor, theme, isDark),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '₹${item.totalPrice.toStringAsFixed(0)}',
                        style: theme.textTheme.titleLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w900),
                      ),
                      
                      // Quantity controls
                      Row(
                        children: [
                          _buildQuantityButton(
                            Icons.remove,
                            () => context.read<CartBloc>().add(UpdateQuantityEvent(item.id, item.quantity - 1)),
                            theme,
                            isDark,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Text(
                              '${item.quantity}',
                              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          _buildQuantityButton(
                            Icons.add,
                            () => context.read<CartBloc>().add(UpdateQuantityEvent(item.id, item.quantity + 1)),
                            theme,
                            isDark,
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.softGrey,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: isDark ? AppColors.darkBorder : Colors.transparent),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onTap, ThemeData theme, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 14),
      ),
    );
  }

  Widget _buildPromoSection(CartLoadedState state, ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROMO CODE',
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.0),
          ),
          const SizedBox(height: 10),
          if (state.appliedPromoCode == null)
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _promoController,
                    decoration: const InputDecoration(
                      hintText: 'Enter coupon code (LUXE10, FIRSTBUY)',
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => _applyPromo(context),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(90, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('APPLY', style: TextStyle(fontSize: 12)),
                ),
              ],
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1B2E1E) : const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        'Coupon "${state.appliedPromoCode}" Applied!',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel_outlined, color: Colors.green, size: 20),
                    onPressed: () {
                      context.read<CartBloc>().add(RemovePromoCodeEvent());
                      _promoController.clear();
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWalletSection(CartLoadedState state, ThemeData theme, bool isDark) {
    final balance = MockDatabase.walletCashback;
    if (balance <= 0) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_wallet_outlined, color: isDark ? AppColors.darkAccent : AppColors.lightAccent, size: 24),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'USE WALLET BALANCE',
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.0),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Available: ₹${balance.toStringAsFixed(0)}',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: state.useWallet,
            activeColor: isDark ? AppColors.darkAccent : AppColors.lightAccent,
            onChanged: (val) {
              context.read<CartBloc>().add(ToggleWalletDeductionEvent(val));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSummary(CartLoadedState state, ThemeData theme, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRICE SUMMARY',
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.0),
          ),
          const SizedBox(height: 14),
          _buildSummaryRow('Bag Subtotal', '₹${state.subtotal.toStringAsFixed(0)}', theme, isDark),
          if (state.discount > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Coupon Discount',
              '- ₹${state.discount.toStringAsFixed(0)}',
              theme,
              isDark,
              textColor: Colors.red,
            ),
          ],
          if (state.walletDeduction > 0) ...[
            const SizedBox(height: 8),
            _buildSummaryRow(
              'Wallet Applied',
              '- ₹${state.walletDeduction.toStringAsFixed(0)}',
              theme,
              isDark,
              textColor: isDark ? AppColors.darkAccent : AppColors.premiumAmber,
            ),
          ],
          const SizedBox(height: 8),
          _buildSummaryRow('Delivery Charge', 'FREE', theme, isDark, textColor: Colors.green),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 12),
          _buildSummaryRow(
            'Total Amount',
            '₹${state.total.toStringAsFixed(0)}',
            theme,
            isDark,
            isBold: true,
            fontSize: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    ThemeData theme,
    bool isDark, {
    bool isBold = false,
    double fontSize = 14,
    Color? textColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: fontSize,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.w900 : FontWeight.normal,
            fontSize: fontSize,
            color: textColor ?? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          ),
        ),
      ],
    );
  }

  Widget _buildFooterBar(CartLoadedState state, BuildContext context, bool isDark) {
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
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL AMOUNT',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
                Text(
                  '₹${state.total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(180, 52),
            ),
            onPressed: () {
              context.push('/checkout');
            },
            child: const Text('CHECKOUT'),
          ),
        ],
      ),
    );
  }
}

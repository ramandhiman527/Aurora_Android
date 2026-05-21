import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/data/mock_database.dart';
import '../../../../core/models/ecommerce_models.dart';
import '../../../../core/theme/colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(LoadOrdersEvent());
  }

  String _getCustomerRank(int orderCount) {
    if (orderCount >= 10) return 'PLATINUM ELITE';
    if (orderCount >= 5) return 'GOLD MEMBER';
    return 'SILVER STANDARD';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnauthenticatedState) {
          context.go('/login');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('MY ACCOUNT'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              onPressed: () => context.push('/settings'),
            )
          ],
        ),
        body: BlocBuilder<OrderBloc, OrderState>(
          builder: (context, orderState) {
            final ordersList = orderState is OrdersLoadedState ? orderState.orders : MockDatabase.orders;
            final rank = _getCustomerRank(ordersList.length);

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  _buildProfileHeader(rank, theme, isDark),
                  const SizedBox(height: 24),
                  
                  // Quick Info Widgets Grid
                  _buildActionCards(theme, isDark),
                  const SizedBox(height: 28),

                  // Past Orders Section
                  Text(
                    'ORDER HISTORY',
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 12),
                  _buildOrderHistoryList(ordersList, theme, isDark),
                  const SizedBox(height: 24),

                  // Logout Button
                  Center(
                    child: TextButton.icon(
                      icon: const Icon(Icons.logout_outlined, color: Colors.red),
                      label: const Text('LOGOUT OF SESSION', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutEvent());
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String rank, ThemeData theme, bool isDark) {
    final goldColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;

    return Row(
      children: [
        CircleAvatar(
          radius: 36,
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightPrimary,
          child: const Text(
            'BC',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bhawana Chandel',
                style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                '+91 98765 43210',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 6),
              
              // Loyalty Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF221C12) : const Color(0xFFF9F3EA),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: goldColor, width: 0.5),
                ),
                child: Text(
                  rank,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkAccent : AppColors.premiumAmber,
                    letterSpacing: 1.0,
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildActionCards(ThemeData theme, bool isDark) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 2.2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildQuickCard('Saved Addresses', Icons.location_on_outlined, () {}, theme, isDark),
        _buildQuickCard('My Wishlist', Icons.favorite_border, () => context.go('/discover'), theme, isDark),
        _buildQuickCard('Aura Wallet', Icons.account_balance_wallet_outlined, () => context.go('/wallet'), theme, isDark),
        _buildQuickCard('Vouchers/Coupons', Icons.card_membership_outlined, () => context.go('/cart'), theme, isDark),
      ],
    );
  }

  Widget _buildQuickCard(String title, IconData icon, VoidCallback onTap, ThemeData theme, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        ),
        child: Row(
          children: [
            Icon(icon, color: isDark ? AppColors.darkAccent : AppColors.lightAccent, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderHistoryList(List<Order> list, ThemeData theme, bool isDark) {
    if (list.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: const Text('You have not placed any orders yet.'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final order = list[index];
        return GestureDetector(
          onTap: () => context.push('/order-tracking/${order.id}'),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    order.items[0].product.imageUrls[0],
                    width: 60,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id}',
                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Placed on: ${order.orderDate.day}/${order.orderDate.month}/${order.orderDate.year}',
                        style: theme.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _getOrderStatusText(order.status).toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getOrderStatusColor(order.status),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getOrderStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.packed:
        return 'Packed';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  Color _getOrderStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.preparing:
      case OrderStatus.packed:
        return Colors.orange;
      case OrderStatus.shipped:
      case OrderStatus.outForDelivery:
        return Colors.blue;
      case OrderStatus.delivered:
        return Colors.green;
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/data/mock_database.dart';
import '../../../../core/models/ecommerce_models.dart';
import '../../../../core/theme/colors.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    context.read<OrderBloc>().add(LoadOrdersEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ADMIN CONSOLE'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          indicatorColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
          tabs: const [
            Tab(text: 'ANALYTICS'),
            Tab(text: 'INVENTORY'),
            Tab(text: 'ORDERS'),
          ],
        ),
      ),
      body: BlocConsumer<OrderBloc, OrderState>(
        listener: (context, state) {
          if (state is OrdersLoadedState && state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 1),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is OrdersLoadedState) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildAnalyticsTab(state, theme, isDark),
                _buildInventoryTab(state.adminProducts, theme, isDark),
                _buildOrdersTab(state.orders, theme, isDark),
              ],
            );
          } else {
            return const Center(child: Text('Failed to load admin stats.'));
          }
        },
      ),
    );
  }

  Widget _buildAnalyticsTab(OrdersLoadedState state, ThemeData theme, bool isDark) {
    double totalRevenue = 0;
    int itemsCount = 0;
    for (var o in state.orders) {
      totalRevenue += o.paidAmount;
      for (var item in o.items) {
        itemsCount += item.quantity;
      }
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('STORE METRICS', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _buildMetricCard('Total Revenue', '₹${totalRevenue.toStringAsFixed(0)}', Icons.monetization_on_outlined, theme, isDark),
              _buildMetricCard('Total Orders', '${state.orders.length}', Icons.shopping_bag_outlined, theme, isDark),
              _buildMetricCard('Units Dispatched', '$itemsCount', Icons.inventory_2_outlined, theme, isDark),
              _buildMetricCard('Wallet Cashback', '₹${MockDatabase.walletCashback.toStringAsFixed(0)}', Icons.wallet_giftcard_outlined, theme, isDark),
            ],
          ),
          
          const SizedBox(height: 32),
          Text('AI CUSTOMER RANKINGS (AI-READY)', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.0, color: Colors.blue)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.amber, size: 22),
                    const SizedBox(width: 10),
                    Text('VIP Loyalty Classifications', style: theme.textTheme.titleLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'The predictive model assigns customers into Bronze, Silver, Gold, or Platinum buckets. Gold and Platinum buckets are automatically unlocked to receive targeted email voucher codes.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: isDark ? AppColors.darkAccent : AppColors.lightAccent, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, fontSize: 18)),
              const SizedBox(height: 2),
              Text(title, style: theme.textTheme.bodySmall?.copyWith(fontSize: 11)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInventoryTab(List<Product> products, ThemeData theme, bool isDark) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
        foregroundColor: isDark ? AppColors.darkBackground : AppColors.lightSurface,
        icon: const Icon(Icons.add),
        label: const Text('NEW PRODUCT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
        onPressed: () {
          // Add a new mock product
          final newProduct = Product(
            id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
            name: 'Aura Premium Leather Slippers',
            description: 'Minimalist leather slides featuring ergonomic footbeds and hand-stitched detailing.',
            price: 4999.0,
            categoryId: 'cat3',
            imageUrls: const ['https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=800&q=80'],
            availableSizes: const ['M', 'L'],
            availableColors: const ['Chestnut Brown', 'Midnight Black'],
          );
          context.read<OrderBloc>().add(AdminAddProductEvent(newProduct));
        },
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final prod = products[index];
          final isLowStock = prod.stockCount < 10;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(prod.imageUrls[0], width: 50, height: 60, fit: BoxFit.cover),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(prod.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 3),
                      Text('Price: ₹${prod.price.toStringAsFixed(0)}', style: theme.textTheme.bodySmall),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text('Stock: ${prod.stockCount}', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: isLowStock ? Colors.red : Colors.green)),
                          if (isLowStock) ...[
                            const SizedBox(width: 8),
                            const Text('LOW STOCK', style: TextStyle(color: Colors.red, fontSize: 8, fontWeight: FontWeight.bold)),
                          ]
                        ],
                      )
                    ],
                  ),
                ),
                
                // Add/subtract stock control
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, size: 18),
                      onPressed: () => context.read<OrderBloc>().add(AdminUpdateStockEvent(prod.id, prod.stockCount + 5)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, size: 18, color: Colors.red),
                      onPressed: () => context.read<OrderBloc>().add(AdminUpdateStockEvent(prod.id, prod.stockCount - 1)),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  onPressed: () => context.read<OrderBloc>().add(AdminDeleteProductEvent(prod.id)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOrdersTab(List<Order> orders, ThemeData theme, bool isDark) {
    if (orders.isEmpty) {
      return const Center(child: Text('No orders placed yet.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order #${order.id}', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(
                    _getOrderStatusText(order.status).toUpperCase(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: _getOrderStatusColor(order.status)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text('Items: ${order.items.length} units  |  Paid Amount: ₹${order.paidAmount.toStringAsFixed(0)}', style: theme.textTheme.bodySmall),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Update Status:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  DropdownButton<OrderStatus>(
                    value: order.status,
                    style: TextStyle(fontSize: 12, color: isDark ? Colors.white : Colors.black),
                    underline: const SizedBox(),
                    items: OrderStatus.values.map((status) {
                      return DropdownMenuItem<OrderStatus>(
                        value: status,
                        child: Text(_getOrderStatusText(status)),
                      );
                    }).toList(),
                    onChanged: (newStatus) {
                      if (newStatus != null) {
                        context.read<OrderBloc>().add(AdminUpdateOrderStatusEvent(order.id, newStatus));
                      }
                    },
                  ),
                ],
              ),
            ],
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

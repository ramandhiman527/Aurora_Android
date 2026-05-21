import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/data/mock_database.dart';
import '../../../../core/models/ecommerce_models.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/order_bloc.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const OrderTrackingScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late Order _order;

  @override
  void initState() {
    super.initState();
    _fetchOrder();
  }

  void _fetchOrder() {
    _order = MockDatabase.orders.firstWhere(
      (o) => o.id == widget.orderId,
      orElse: () => MockDatabase.orders[0],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrdersLoadedState) {
          setState(() {
            _fetchOrder();
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('ORDER #${_order.id}'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
            onPressed: () => context.go('/profile'), // Nav back to orders history in profile tab
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary card
              _buildSummaryHeader(theme, isDark),
              const SizedBox(height: 24),
              
              // Timeline timeline steps
              Text(
                'SHIPMENT TRACKING',
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
              const SizedBox(height: 16),
              _buildTrackingTimeline(theme, isDark),
              
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              
              // Delivery Details
              Text(
                'DELIVERY ADDRESS',
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
              const SizedBox(height: 10),
              Text(
                _order.deliveryAddress.fullName,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '${_order.deliveryAddress.streetAddress}, ${_order.deliveryAddress.city}, ${_order.deliveryAddress.state} - ${_order.deliveryAddress.postalCode}',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              
              // Order Items list
              Text(
                'ITEMS ORDERED',
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _order.items.length,
                itemBuilder: (context, index) {
                  final item = _order.items[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(item.product.imageUrls[0], width: 50, height: 60, fit: BoxFit.cover),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.product.name, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                              Text('Qty: ${item.quantity}  |  Size: ${item.selectedSize}', style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                        Text('₹${item.totalPrice.toStringAsFixed(0)}', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryHeader(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.softGrey,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : Colors.transparent),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status', style: theme.textTheme.bodySmall),
              const SizedBox(height: 3),
              Text(
                _getStatusText(_order.status).toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkAccent : AppColors.premiumAmber,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Tracking ID', style: theme.textTheme.bodySmall),
              const SizedBox(height: 3),
              Text(
                _order.trackingId.substring(0, 12),
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.preparing:
        return 'Preparing Package';
      case OrderStatus.packed:
        return 'Order Packed';
      case OrderStatus.shipped:
        return 'Shipped Out';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered Successfully';
    }
  }

  Widget _buildTrackingTimeline(ThemeData theme, bool isDark) {
    final currentStatusIndex = _order.status.index;

    return Column(
      children: [
        _buildTimelineStep(
          'Preparing Package',
          'We have received your order and are packing items.',
          currentStatusIndex >= 0,
          currentStatusIndex == 0,
          theme,
          isDark,
        ),
        _buildTimelineLine(currentStatusIndex > 0, isDark),
        _buildTimelineStep(
          'Order Packed',
          'Your package has been security sealed and labeled.',
          currentStatusIndex >= 1,
          currentStatusIndex == 1,
          theme,
          isDark,
        ),
        _buildTimelineLine(currentStatusIndex > 1, isDark),
        _buildTimelineStep(
          'Shipped Out',
          'In transit. Left sorting facility towards nearest hub.',
          currentStatusIndex >= 2,
          currentStatusIndex == 2,
          theme,
          isDark,
        ),
        _buildTimelineLine(currentStatusIndex > 2, isDark),
        _buildTimelineStep(
          'Out for Delivery',
          'Package arrived in your city. Courier agent in transit.',
          currentStatusIndex >= 3,
          currentStatusIndex == 3,
          theme,
          isDark,
        ),
        _buildTimelineLine(currentStatusIndex > 3, isDark),
        _buildTimelineStep(
          'Delivered',
          'Package signed and handed over to customer.',
          currentStatusIndex >= 4,
          currentStatusIndex == 4,
          theme,
          isDark,
        ),
      ],
    );
  }

  Widget _buildTimelineStep(
    String title,
    String subtitle,
    bool isCompleted,
    bool isActive,
    ThemeData theme,
    bool isDark,
  ) {
    final goldColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isCompleted
                ? (isActive ? goldColor : Colors.green)
                : (isDark ? AppColors.darkSurface : AppColors.softGrey),
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted
                  ? Colors.transparent
                  : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
          ),
          child: Icon(
            isCompleted ? (isActive ? Icons.lens : Icons.check) : Icons.radio_button_off,
            size: isActive ? 8 : 14,
            color: isCompleted ? Colors.white : Colors.grey,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isCompleted
                      ? (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary)
                      : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineLine(bool isCompleted, bool isDark) {
    return Container(
      width: 2,
      height: 32,
      margin: const EdgeInsets.only(left: 11),
      color: isCompleted
          ? Colors.green
          : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
    );
  }
}

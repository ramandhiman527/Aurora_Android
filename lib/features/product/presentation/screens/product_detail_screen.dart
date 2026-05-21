import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/data/mock_database.dart';
import '../../../../core/models/ecommerce_models.dart';
import '../../../../core/theme/colors.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../catalog/presentation/bloc/catalog_bloc.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({Key? key, required this.productId}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Product _product;
  int _activeImageIndex = 0;
  String? _selectedSize;
  String? _selectedColor;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _product = MockDatabase.products.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => MockDatabase.products[0],
    );
    if (_product.availableSizes.isNotEmpty) {
      _selectedSize = _product.availableSizes[0];
    }
    if (_product.availableColors.isNotEmpty) {
      _selectedColor = _product.availableColors[0];
    }
  }

  void _onAddToCart(BuildContext context) {
    if (_selectedSize == null || _selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select size and color.')),
      );
      return;
    }
    context.read<CartBloc>().add(AddToCartEvent(
          product: _product,
          size: _selectedSize!,
          color: _selectedColor!,
          quantity: 1,
        ));
  }

  void _onBuyNow(BuildContext context) {
    if (_selectedSize == null || _selectedColor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select size and color.')),
      );
      return;
    }
    context.read<CartBloc>().add(AddToCartEvent(
          product: _product,
          size: _selectedSize!,
          color: _selectedColor!,
          quantity: 1,
        ));
    context.push('/checkout');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Check wishlist state
    return BlocConsumer<CatalogBloc, CatalogState>(
      listener: (context, state) {
        if (state is CatalogLoaded) {
          setState(() {
            _isLiked = state.wishlist.contains(_product);
          });
        }
      },
      builder: (context, state) {
        if (state is CatalogLoaded) {
          _isLiked = state.wishlist.contains(_product);
        }

        return BlocListener<CartBloc, CartState>(
          listener: (context, cartState) {
            if (cartState is CartLoadedState && cartState.message != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(cartState.message!),
                  backgroundColor: AppColors.success,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(_product.name.toUpperCase(), style: const TextStyle(fontSize: 13, letterSpacing: 1.5)),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                onPressed: () => context.pop(),
              ),
              actions: [
                IconButton(
                  icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border, color: _isLiked ? Colors.red : null),
                  onPressed: () {
                    context.read<CatalogBloc>().add(ToggleWishlistEvent(_product));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_bag_outlined),
                  onPressed: () => context.go('/cart'),
                ),
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Gallery Slider
                        _buildImageGallery(isDark),

                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title & Price Section
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _product.name,
                                          style: theme.textTheme.headlineLarge?.copyWith(fontSize: 22),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          MockDatabase.categories.firstWhere((c) => c.id == _product.categoryId).name.toUpperCase(),
                                          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '₹${_product.price.toStringAsFixed(0)}',
                                        style: theme.textTheme.headlineMedium?.copyWith(
                                          fontWeight: FontWeight.w900,
                                          color: isDark ? AppColors.darkAccent : AppColors.lightPrimary,
                                        ),
                                      ),
                                      if (_product.hasDiscount) ...[
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Text(
                                              '₹${_product.originalPrice!.toStringAsFixed(0)}',
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              '${_product.discountPercentage}% OFF',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 24),
                              const Divider(),
                              const SizedBox(height: 16),

                              // Description
                              Text(
                                'THE DESIGN',
                                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _product.description,
                                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                              ),

                              const SizedBox(height: 24),

                              // Size Selector
                              Text(
                                'SELECT SIZE',
                                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 10,
                                children: _product.availableSizes.map((size) {
                                  final isSelected = _selectedSize == size;
                                  return GestureDetector(
                                    onTap: () => setState(() => _selectedSize = size),
                                    child: Container(
                                      height: 48,
                                      width: 56,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: isSelected
                                              ? Colors.transparent
                                              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                                        ),
                                      ),
                                      child: Text(
                                        size,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: isSelected
                                              ? (isDark ? AppColors.darkBackground : AppColors.lightSurface)
                                              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),

                              const SizedBox(height: 24),

                              // Color Selector
                              Text(
                                'SELECT COLOR',
                                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 10,
                                children: _product.availableColors.map((color) {
                                  final isSelected = _selectedColor == color;
                                  return GestureDetector(
                                    onTap: () => setState(() => _selectedColor = color),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                                            : (isDark ? AppColors.darkSurface : AppColors.softGrey),
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: isSelected ? Colors.transparent : (isDark ? AppColors.darkBorder : Colors.transparent),
                                        ),
                                      ),
                                      child: Text(
                                        color,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? (isDark ? AppColors.darkBackground : AppColors.lightSurface)
                                              : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),

                              const SizedBox(height: 24),
                              const Divider(),
                              const SizedBox(height: 16),

                              // Delivery Estimate
                              _buildDeliveryEstimateCard(theme, isDark),

                              const SizedBox(height: 24),
                              const Divider(),
                              const SizedBox(height: 16),

                              // Ratings & Reviews
                              _buildReviewsSection(theme, isDark),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Action buttons: Buy/Add to Cart
                _buildActionDock(context, isDark),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageGallery(bool isDark) {
    return Column(
      children: [
        SizedBox(
          height: 380,
          child: PageView.builder(
            itemCount: _product.imageUrls.length,
            onPageChanged: (index) {
              setState(() {
                _activeImageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                _product.imageUrls[index],
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_product.imageUrls.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 4,
              width: _activeImageIndex == index ? 20 : 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: _activeImageIndex == index
                    ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDeliveryEstimateCard(ThemeData theme, bool isDark) {
    return Row(
      children: [
        Icon(Icons.local_shipping_outlined, color: isDark ? AppColors.darkAccent : AppColors.lightAccent, size: 24),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DELIVERY ESTIMATE',
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.0),
              ),
              const SizedBox(height: 3),
              Text(
                'FREE Delivery in 48 Hours. Guaranteed by day after tomorrow.',
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection(ThemeData theme, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RATINGS & REVIEWS (${_product.totalReviews})',
              style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  _product.averageRating.toString(),
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_product.reviews.isEmpty)
          const Text('No reviews for this product yet.')
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _product.reviews.length,
            itemBuilder: (context, index) {
              final review = _product.reviews[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          review.username,
                          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: List.generate(5, (starIndex) {
                            return Icon(
                              Icons.star,
                              size: 12,
                              color: starIndex < review.rating.floor() ? Colors.amber : Colors.grey,
                            );
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      review.comment,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${review.date.day}/${review.date.month}/${review.date.year}',
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildActionDock(BuildContext context, bool isDark) {
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
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                side: BorderSide(color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
              ),
              onPressed: () => _onAddToCart(context),
              child: const Text('ADD TO BAG'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                foregroundColor: isDark ? AppColors.darkBackground : AppColors.lightSurface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
              ),
              onPressed: () => _onBuyNow(context),
              child: const Text('BUY NOW'),
            ),
          ),
        ],
      ),
    );
  }
}

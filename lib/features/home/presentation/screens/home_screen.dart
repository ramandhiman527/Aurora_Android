import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/data/mock_database.dart';
import '../../../../core/models/ecommerce_models.dart';
import '../../../../core/shared_widgets/loading_shimmer.dart';
import '../../../../core/theme/colors.dart';
import '../../../catalog/presentation/bloc/catalog_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _activeFeaturedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Dispatch catalog load if state is initial
    final bloc = context.read<CatalogBloc>();
    if (bloc.state is CatalogInitial) {
      bloc.add(LoadCatalogEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AURA',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined),
            onPressed: () => context.push('/admin'),
          ),
        ],
      ),
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          if (state is CatalogLoading || state is CatalogInitial) {
            return _buildSkeletonLoader();
          } else if (state is CatalogLoaded) {
            final products = state.products;
            final featuredList = products.where((p) => p.isFeatured).toList();
            final trendingList = products.where((p) => p.isTrending).toList();
            final newArrivals = products.where((p) => p.isNewArrival).toList();
            final limitedEdition = products.where((p) => p.isLimitedEdition).toList();

            return RefreshIndicator(
              onRefresh: () async {
                context.read<CatalogBloc>().add(LoadCatalogEvent());
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Categories horizontal row
                    _buildCategoriesRow(theme, isDark),
                    
                    // Featured Sliding Carousel
                    if (featuredList.isNotEmpty)
                      _buildFeaturedCarousel(featuredList, theme, isDark),

                    // 48-Hour delivery banner
                    _buildDeliveryBanner(theme, isDark),

                    // Trending products list
                    if (trendingList.isNotEmpty)
                      _buildProductHorizontalList('TRENDING ITEMS', trendingList, theme, isDark, state.wishlist),

                    // Limited Edition Highlights
                    if (limitedEdition.isNotEmpty)
                      _buildLimitedEditionShowcase(limitedEdition[0], theme, isDark),

                    // New Arrivals
                    if (newArrivals.isNotEmpty)
                      _buildProductHorizontalList('NEW ARRIVALS', newArrivals, theme, isDark, state.wishlist),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('Failed to load items.'));
          }
        },
      ),
    );
  }

  Widget _buildCategoriesRow(ThemeData theme, bool isDark) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: MockDatabase.categories.length,
        itemBuilder: (context, index) {
          final cat = MockDatabase.categories[index];
          return GestureDetector(
            onTap: () {
              context.read<CatalogBloc>().add(ApplyFiltersEvent(categoryId: cat.id));
              context.go('/discover');
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundImage: NetworkImage(cat.imageUrl),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cat.name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedCarousel(List<Product> list, ThemeData theme, bool isDark) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            itemCount: list.length,
            onPageChanged: (index) {
              setState(() {
                _activeFeaturedIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final prod = list[index];
              return GestureDetector(
                onTap: () => context.push('/product/${prod.id}'),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(
                      image: NetworkImage(prod.imageUrls[0]),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (prod.isLimitedEdition)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            margin: const EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkAccent : AppColors.lightAccent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'LIMITED',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        Text(
                          prod.name,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${prod.price.toStringAsFixed(0)}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(list.length, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
              width: _activeFeaturedIndex == index ? 16 : 6,
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: _activeFeaturedIndex == index
                    ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
                    : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDeliveryBanner(ThemeData theme, bool isDark) {
    final goldColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141414) : Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: goldColor, width: 0.5),
      ),
      child: Row(
        children: [
          Icon(Icons.bolt, color: goldColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'EXPRESS 48H SHIPMENT',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Order before 4 PM and receive delivery within 2 days. Valid nationwide.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.65),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProductHorizontalList(
    String title,
    List<Product> list,
    ThemeData theme,
    bool isDark,
    List<Product> wishlist,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: 14,
                ),
              ),
              GestureDetector(
                onTap: () {
                  context.read<CatalogBloc>().add(ApplyFiltersEvent(sortBy: 'rating'));
                  context.go('/discover');
                },
                child: Text(
                  'VIEW ALL',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkAccent : AppColors.lightAccent,
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final prod = list[index];
              final isLiked = wishlist.contains(prod);

              return GestureDetector(
                onTap: () => context.push('/product/${prod.id}'),
                child: Container(
                  width: 154,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              prod.imageUrls[0],
                              height: 170,
                              width: 154,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                context.read<CatalogBloc>().add(ToggleWishlistEvent(prod));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: isDark ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.85),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isLiked ? Icons.favorite : Icons.favorite_border,
                                  size: 16,
                                  color: isLiked ? Colors.red : (isDark ? Colors.white : Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        prod.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '₹${prod.price.toStringAsFixed(0)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                            ),
                          ),
                          if (prod.hasDiscount) ...[
                            const SizedBox(width: 6),
                            Text(
                              '₹${prod.originalPrice!.toStringAsFixed(0)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                              ),
                            ),
                          ]
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildLimitedEditionShowcase(Product prod, ThemeData theme, bool isDark) {
    return GestureDetector(
      onTap: () => context.push('/product/${prod.id}'),
      child: Container(
        margin: const EdgeInsets.all(16),
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: NetworkImage(prod.imageUrls[0]),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.1),
              ],
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LIMITED RELEASE',
                      style: TextStyle(
                        color: isDark ? AppColors.darkAccent : AppColors.lightAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      prod.name,
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Collectible items with custom branding.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.white,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Categories shimmer
          Row(
            children: List.generate(4, (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: LoadingShimmer.circular(width: 56, height: 56),
            )),
          ),
          const SizedBox(height: 24),
          // Featured carousel shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LoadingShimmer.rectangular(height: 200),
          ),
          const SizedBox(height: 24),
          // Banner shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LoadingShimmer.rectangular(height: 60),
          ),
          const SizedBox(height: 24),
          // Horizontal list shimmer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: List.generate(2, (index) => Expanded(
                child: LoadingShimmer.productCardPlaceholder(),
              )),
            ),
          )
        ],
      ),
    );
  }
}

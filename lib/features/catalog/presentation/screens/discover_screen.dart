import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/data/mock_database.dart';
import '../../../../core/models/ecommerce_models.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/catalog_bloc.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  bool _showSuggestions = false;

  final List<String> _trendingKeywords = ['HMD Crest', 'Formal Shoes', 'Messenger Bag', 'Leather Belt', 'UPI Mobile'];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _focusNode.removeListener(_onFocusChanged);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<CatalogBloc>().add(SearchQueryChangedEvent(_searchController.text));
    setState(() {
      _showSuggestions = _searchController.text.isNotEmpty && _focusNode.hasFocus;
    });
  }

  void _onFocusChanged() {
    setState(() {
      _showSuggestions = _focusNode.hasFocus && _searchController.text.isNotEmpty;
    });
  }

  void _openFilterDrawer(BuildContext context, CatalogLoaded loadedState) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FilterBottomSheet(loadedState: loadedState);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DISCOVER'),
      ),
      body: BlocBuilder<CatalogBloc, CatalogState>(
        builder: (context, state) {
          if (state is CatalogLoading || state is CatalogInitial) {
            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
          } else if (state is CatalogLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar row
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _searchController,
                          focusNode: _focusNode,
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: 'Search mobiles, footwear, leather goods...',
                            prefixIcon: const Icon(Icons.search_outlined, size: 20),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close, size: 16),
                                    onPressed: () {
                                      _searchController.clear();
                                      _focusNode.unfocus();
                                    },
                                  )
                                : null,
                            contentPadding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => _openFilterDrawer(context, state),
                        child: Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                            ),
                          ),
                          child: Icon(
                            Icons.tune_outlined,
                            color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Suggestion Overlay or Content
                Expanded(
                  child: _showSuggestions
                      ? _buildSuggestionsList(state.products, theme, isDark)
                      : _searchController.text.isEmpty
                          ? _buildTrendingSection(theme, isDark)
                          : _buildProductGrid(state.products, state.wishlist, theme, isDark),
                ),
              ],
            );
          } else {
            return const Center(child: Text('Something went wrong.'));
          }
        },
      ),
    );
  }

  Widget _buildSuggestionsList(List<Product> products, ThemeData theme, bool isDark) {
    if (products.isEmpty) {
      return const Center(child: Text('No matches found. Try searching something else.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: products.length > 5 ? 5 : products.length,
      itemBuilder: (context, index) {
        final prod = products[index];
        return ListTile(
          leading: Image.network(prod.imageUrls[0], width: 40, height: 40, fit: BoxFit.cover),
          title: Text(prod.name, style: theme.textTheme.bodyMedium),
          trailing: const Icon(Icons.arrow_outward, size: 16),
          onTap: () {
            _focusNode.unfocus();
            context.push('/product/${prod.id}');
          },
        );
      },
    );
  }

  Widget _buildTrendingSection(ThemeData theme, bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TRENDING SEARCHES',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: _trendingKeywords.map((kw) {
              return GestureDetector(
                onTap: () {
                  _searchController.text = kw;
                  _focusNode.unfocus();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.softGrey,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_up, size: 14, color: isDark ? AppColors.darkAccent : AppColors.lightAccent),
                      const SizedBox(width: 6),
                      Text(
                        kw,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 40),
          
          Text(
            'PERSONALIZED SUGGESTIONS (AI-READY)',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: isDark ? AppColors.darkAccent : AppColors.lightAccent,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.amber, size: 24),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Smart Styling Recommendations',
                        style: theme.textTheme.titleLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Our AI stylist is analyzing your browse history. Check back soon for handpicked collections matching your wardrobe preferences.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid(List<Product> list, List<Product> wishlist, ThemeData theme, bool isDark) {
    if (list.isEmpty) {
      return const Center(child: Text('No results match your search parameters.'));
    }
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.64,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final prod = list[index];
        final isLiked = wishlist.contains(prod);

        return GestureDetector(
          onTap: () => context.push('/product/${prod.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      prod.imageUrls[0],
                      height: 180,
                      width: double.infinity,
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
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '₹${prod.price.toStringAsFixed(0)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Filter Bottom Sheet Widget
class FilterBottomSheet extends StatefulWidget {
  final CatalogLoaded loadedState;

  const FilterBottomSheet({Key? key, required this.loadedState}) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  String? _categoryId;
  double _maxPrice = 25000;
  String? _selectedSize;
  String? _selectedColor;
  String? _sortBy;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.loadedState.selectedCategoryId;
    _maxPrice = widget.loadedState.selectedMaxPrice ?? 25000;
    _selectedSize = widget.loadedState.selectedSize;
    _selectedColor = widget.loadedState.selectedColor;
    _sortBy = widget.loadedState.selectedSortBy;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FILTER & SORT',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5, fontSize: 14),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _categoryId = null;
                    _maxPrice = 25000;
                    _selectedSize = null;
                    _selectedColor = null;
                    _sortBy = null;
                  });
                },
                child: Text(
                  'CLEAR ALL',
                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Sort Options
          Text('SORT BY', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildFilterChip('Price: Low-High', _sortBy == 'low_to_high', () => setState(() => _sortBy = 'low_to_high'), theme, isDark),
              const SizedBox(width: 8),
              _buildFilterChip('Price: High-Low', _sortBy == 'high_to_low', () => setState(() => _sortBy = 'high_to_low'), theme, isDark),
              const SizedBox(width: 8),
              _buildFilterChip('Top Rated', _sortBy == 'rating', () => setState(() => _sortBy = 'rating'), theme, isDark),
            ],
          ),
          const SizedBox(height: 18),

          // Category Chips
          Text('CATEGORY', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: MockDatabase.categories.map((c) {
              final isSelected = _categoryId == c.id;
              return _buildFilterChip(c.name, isSelected, () {
                setState(() {
                  _categoryId = isSelected ? null : c.id;
                });
              }, theme, isDark);
            }).toList(),
          ),
          const SizedBox(height: 18),

          // Price Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('MAX PRICE', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
              Text('₹${_maxPrice.toStringAsFixed(0)}', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          Slider(
            value: _maxPrice,
            min: 2000,
            max: 25000,
            divisions: 23,
            activeColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
            inactiveColor: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            onChanged: (val) {
              setState(() {
                _maxPrice = val;
              });
            },
          ),
          const SizedBox(height: 12),

          // Size Selection
          Text('SIZE / VARIANT', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['UK 8', 'UK 9', 'UK 10', '34', '36', '8GB + 256GB', '6GB + 128GB'].map((s) {
              final isSelected = _selectedSize == s;
              return _buildFilterChip(s, isSelected, () {
                setState(() {
                  _selectedSize = isSelected ? null : s;
                });
              }, theme, isDark);
            }).toList(),
          ),
          
          const SizedBox(height: 32),
          
          // Apply Button
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 54),
            ),
            onPressed: () {
              context.read<CatalogBloc>().add(ApplyFiltersEvent(
                    categoryId: _categoryId,
                    maxPrice: _maxPrice,
                    size: _selectedSize,
                    color: _selectedColor,
                    sortBy: _sortBy,
                  ));
              context.pop();
            },
            child: const Text('APPLY FILTERS'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String text, bool isSelected, VoidCallback onTap, ThemeData theme, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.darkPrimary : AppColors.lightPrimary)
              : (isDark ? AppColors.darkSurface : AppColors.softGrey),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : (isDark ? AppColors.darkBorder : Colors.transparent),
          ),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected
                ? (isDark ? AppColors.darkBackground : AppColors.lightSurface)
                : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
          ),
        ),
      ),
    );
  }
}

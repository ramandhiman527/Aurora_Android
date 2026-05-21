import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/models/ecommerce_models.dart';
import '../../../../core/data/mock_database.dart';

// --- CATALOG EVENTS ---
abstract class CatalogEvent extends Equatable {
  const CatalogEvent();
  @override
  List<Object?> get props => [];
}

class LoadCatalogEvent extends CatalogEvent {}

class SearchQueryChangedEvent extends CatalogEvent {
  final String query;
  const SearchQueryChangedEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class ApplyFiltersEvent extends CatalogEvent {
  final String? categoryId;
  final double? maxPrice;
  final String? size;
  final String? color;
  final String? sortBy; // 'low_to_high', 'high_to_low', 'rating'

  const ApplyFiltersEvent({
    this.categoryId,
    this.maxPrice,
    this.size,
    this.color,
    this.sortBy,
  });

  @override
  List<Object?> get props => [categoryId, maxPrice, size, color, sortBy];
}

class ToggleWishlistEvent extends CatalogEvent {
  final Product product;
  const ToggleWishlistEvent(this.product);
  @override
  List<Object?> get props => [product];
}

// --- CATALOG STATES ---
abstract class CatalogState extends Equatable {
  const CatalogState();
  @override
  List<Object?> get props => [];
}

class CatalogInitial extends CatalogState {}

class CatalogLoading extends CatalogState {}

class CatalogLoaded extends CatalogState {
  final List<Product> products;
  final List<Product> wishlist;
  final String query;
  final String? selectedCategoryId;
  final double? selectedMaxPrice;
  final String? selectedSize;
  final String? selectedColor;
  final String? selectedSortBy;

  const CatalogLoaded({
    required this.products,
    required this.wishlist,
    this.query = '',
    this.selectedCategoryId,
    this.selectedMaxPrice,
    this.selectedSize,
    this.selectedColor,
    this.selectedSortBy,
  });

  CatalogLoaded copyWith({
    List<Product>? products,
    List<Product>? wishlist,
    String? query,
    String? selectedCategoryId,
    double? selectedMaxPrice,
    String? selectedSize,
    String? selectedColor,
    String? selectedSortBy,
  }) {
    return CatalogLoaded(
      products: products ?? this.products,
      wishlist: wishlist ?? this.wishlist,
      query: query ?? this.query,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedMaxPrice: selectedMaxPrice ?? this.selectedMaxPrice,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSortBy: selectedSortBy ?? this.selectedSortBy,
    );
  }

  @override
  List<Object?> get props => [
        products,
        wishlist,
        query,
        selectedCategoryId,
        selectedMaxPrice,
        selectedSize,
        selectedColor,
        selectedSortBy,
      ];
}

class CatalogError extends CatalogState {
  final String message;
  const CatalogError(this.message);
  @override
  List<Object?> get props => [message];
}

// --- CATALOG BLOC ---
class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc() : super(CatalogInitial()) {
    on<LoadCatalogEvent>((event, emit) async {
      emit(CatalogLoading());
      await Future.delayed(const Duration(milliseconds: 500));
      emit(CatalogLoaded(
        products: List.from(MockDatabase.products),
        wishlist: List.from(MockDatabase.wishlist),
      ));
    });

    on<SearchQueryChangedEvent>((event, emit) {
      if (state is CatalogLoaded) {
        final currentState = state as CatalogLoaded;
        final filteredProducts = _filterProducts(
          query: event.query,
          categoryId: currentState.selectedCategoryId,
          maxPrice: currentState.selectedMaxPrice,
          size: currentState.selectedSize,
          color: currentState.selectedColor,
          sortBy: currentState.selectedSortBy,
        );
        emit(currentState.copyWith(
          query: event.query,
          products: filteredProducts,
        ));
      }
    });

    on<ApplyFiltersEvent>((event, emit) {
      if (state is CatalogLoaded) {
        final currentState = state as CatalogLoaded;
        final filteredProducts = _filterProducts(
          query: currentState.query,
          categoryId: event.categoryId,
          maxPrice: event.maxPrice,
          size: event.size,
          color: event.color,
          sortBy: event.sortBy,
        );
        emit(CatalogLoaded(
          products: filteredProducts,
          wishlist: currentState.wishlist,
          query: currentState.query,
          selectedCategoryId: event.categoryId,
          selectedMaxPrice: event.maxPrice,
          selectedSize: event.size,
          selectedColor: event.color,
          selectedSortBy: event.sortBy,
        ));
      }
    });

    on<ToggleWishlistEvent>((event, emit) {
      if (state is CatalogLoaded) {
        final currentState = state as CatalogLoaded;
        final updatedWishlist = List<Product>.from(currentState.wishlist);

        if (updatedWishlist.contains(event.product)) {
          updatedWishlist.remove(event.product);
          MockDatabase.wishlist.remove(event.product);
        } else {
          updatedWishlist.add(event.product);
          MockDatabase.wishlist.add(event.product);
        }

        emit(currentState.copyWith(wishlist: updatedWishlist));
      }
    });
  }

  List<Product> _filterProducts({
    required String query,
    String? categoryId,
    double? maxPrice,
    String? size,
    String? color,
    String? sortBy,
  }) {
    List<Product> list = List.from(MockDatabase.products);

    // Search query match
    if (query.isNotEmpty) {
      final lowercaseQuery = query.toLowerCase();
      list = list.where((p) =>
          p.name.toLowerCase().contains(lowercaseQuery) ||
          p.description.toLowerCase().contains(lowercaseQuery)).toList();
    }

    // Category filter
    if (categoryId != null && categoryId.isNotEmpty) {
      list = list.where((p) => p.categoryId == categoryId).toList();
    }

    // Price filter
    if (maxPrice != null) {
      list = list.where((p) => p.price <= maxPrice).toList();
    }

    // Size filter
    if (size != null && size.isNotEmpty) {
      list = list.where((p) => p.availableSizes.contains(size)).toList();
    }

    // Color filter
    if (color != null && color.isNotEmpty) {
      list = list.where((p) => p.availableColors.contains(color)).toList();
    }

    // Sorting
    if (sortBy != null) {
      if (sortBy == 'low_to_high') {
        list.sort((a, b) => a.price.compareTo(b.price));
      } else if (sortBy == 'high_to_low') {
        list.sort((a, b) => b.price.compareTo(a.price));
      } else if (sortBy == 'rating') {
        list.sort((a, b) => b.averageRating.compareTo(a.averageRating));
      }
    }

    return list;
  }
}

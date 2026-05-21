import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/catalog/presentation/bloc/catalog_bloc.dart';
import 'features/cart/presentation/bloc/cart_bloc.dart';
import 'features/wallet/presentation/bloc/wallet_bloc.dart';
import 'features/orders/presentation/bloc/order_bloc.dart';

class AuraApp extends StatelessWidget {
  const AuraApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(CheckAuthSession()),
        ),
        BlocProvider<CatalogBloc>(
          create: (context) => CatalogBloc()..add(LoadCatalogEvent()),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc()..add(LoadCartEvent()),
        ),
        BlocProvider<WalletBloc>(
          create: (context) => WalletBloc()..add(LoadWalletDetailsEvent()),
        ),
        BlocProvider<OrderBloc>(
          create: (context) => OrderBloc()..add(LoadOrdersEvent()),
        ),
      ],
      child: MaterialApp.router(
        title: 'Aura Premium Fashion',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system, // Dynamically tracks system mode
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

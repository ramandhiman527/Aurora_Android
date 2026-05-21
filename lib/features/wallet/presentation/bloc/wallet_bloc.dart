import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/models/ecommerce_models.dart';
import '../../../../core/data/mock_database.dart';

// --- WALLET EVENTS ---
abstract class WalletEvent extends Equatable {
  const WalletEvent();
  @override
  List<Object?> get props => [];
}

class LoadWalletDetailsEvent extends WalletEvent {}

class ScratchCardRewardEvent extends WalletEvent {}

class ClaimReferralCodeEvent extends WalletEvent {
  final String code;
  const ClaimReferralCodeEvent(this.code);
  @override
  List<Object?> get props => [code];
}

// --- WALLET STATES ---
abstract class WalletState extends Equatable {
  const WalletState();
  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletLoadedState extends WalletState {
  final double cashbackBalance;
  final double rewardsPoints;
  final double referralCredits;
  final List<WalletTransaction> transactions;
  final String? successMessage;
  final double? scratchedRewardAmount;

  const WalletLoadedState({
    required this.cashbackBalance,
    required this.rewardsPoints,
    required this.referralCredits,
    required this.transactions,
    this.successMessage,
    this.scratchedRewardAmount,
  });

  WalletLoadedState copyWith({
    double? cashbackBalance,
    double? rewardsPoints,
    double? referralCredits,
    List<WalletTransaction>? transactions,
    String? successMessage,
    double? scratchedRewardAmount,
  }) {
    return WalletLoadedState(
      cashbackBalance: cashbackBalance ?? this.cashbackBalance,
      rewardsPoints: rewardsPoints ?? this.rewardsPoints,
      referralCredits: referralCredits ?? this.referralCredits,
      transactions: transactions ?? this.transactions,
      successMessage: successMessage,
      scratchedRewardAmount: scratchedRewardAmount,
    );
  }

  @override
  List<Object?> get props => [cashbackBalance, rewardsPoints, referralCredits, transactions, successMessage, scratchedRewardAmount];
}

class WalletError extends WalletState {
  final String message;
  const WalletError(this.message);
  @override
  List<Object?> get props => [message];
}

// --- WALLET BLOC ---
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc() : super(WalletInitial()) {
    on<LoadWalletDetailsEvent>((event, emit) async {
      emit(WalletLoading());
      await Future.delayed(const Duration(milliseconds: 400));
      emit(WalletLoadedState(
        cashbackBalance: MockDatabase.walletCashback,
        rewardsPoints: MockDatabase.walletPoints,
        referralCredits: MockDatabase.walletReferralCredits,
        transactions: List.from(MockDatabase.walletTransactions.reversed),
      ));
    });

    on<ScratchCardRewardEvent>((event, emit) async {
      if (state is WalletLoadedState) {
        final currentState = state as WalletLoadedState;
        emit(WalletLoading());
        await Future.delayed(const Duration(milliseconds: 800));

        // Generate dynamic reward
        final double reward = 75.0; // flat cashback reward
        MockDatabase.walletCashback += reward;
        
        final newTx = WalletTransaction(
          id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
          description: 'Cashback won in Mystery Scratch Card!',
          amount: reward,
          timestamp: DateTime.now(),
          isCredit: true,
        );
        MockDatabase.walletTransactions.add(newTx);

        emit(WalletLoadedState(
          cashbackBalance: MockDatabase.walletCashback,
          rewardsPoints: MockDatabase.walletPoints + 200, // gain points
          referralCredits: MockDatabase.walletReferralCredits,
          transactions: List.from(MockDatabase.walletTransactions.reversed),
          successMessage: 'Congratulations! You won ₹$reward Cashback!',
          scratchedRewardAmount: reward,
        ));
        
        // Save back
        MockDatabase.walletPoints += 200;
      }
    });

    on<ClaimReferralCodeEvent>((event, emit) async {
      if (state is WalletLoadedState) {
        final currentState = state as WalletLoadedState;
        emit(WalletLoading());
        await Future.delayed(const Duration(milliseconds: 1000));

        if (event.code.toUpperCase() == 'RAMAN50') {
          final double credit = 50.0;
          MockDatabase.walletReferralCredits += credit;
          
          final newTx = WalletTransaction(
            id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
            description: 'Referral coupon credit claimed',
            amount: credit,
            timestamp: DateTime.now(),
            isCredit: true,
          );
          MockDatabase.walletTransactions.add(newTx);

          emit(WalletLoadedState(
            cashbackBalance: MockDatabase.walletCashback,
            rewardsPoints: MockDatabase.walletPoints,
            referralCredits: MockDatabase.walletReferralCredits,
            transactions: List.from(MockDatabase.walletTransactions.reversed),
            successMessage: 'Referral credit of ₹$credit added successfully!',
          ));
        } else {
          emit(currentState.copyWith(successMessage: 'Invalid referral code'));
        }
      }
    });
  }
}

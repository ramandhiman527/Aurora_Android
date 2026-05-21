import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/wallet_bloc.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _referralController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<WalletBloc>().add(LoadWalletDetailsEvent());
  }

  @override
  void dispose() {
    _referralController.dispose();
    super.dispose();
  }

  void _claimReferral(BuildContext context) {
    if (_referralController.text.isNotEmpty) {
      context.read<WalletBloc>().add(ClaimReferralCodeEvent(_referralController.text.trim()));
      _referralController.clear();
    }
  }

  void _showScratchCardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            bool isScratched = false;
            return AlertDialog(
              backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: const EdgeInsets.all(24),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'MYSTERY REWARD',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 2.0),
                  ),
                  const SizedBox(height: 16),
                  
                  // Interactive Scratch Area
                  GestureDetector(
                    onTap: () {
                      setDialogState(() {
                        isScratched = true;
                      });
                      context.read<WalletBloc>().add(ScratchCardRewardEvent());
                    },
                    child: Container(
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isScratched ? Colors.transparent : Colors.grey[700],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber, width: 2),
                      ),
                      child: isScratched
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.stars, color: Colors.amber, size: 48),
                                const SizedBox(height: 10),
                                const Text(
                                  'YOU WON!',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                                ),
                                Text(
                                  '₹75 Cashback Credit',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.redeem, color: Colors.white, size: 42),
                                const SizedBox(height: 8),
                                const Text(
                                  'TAP TO SCRATCH',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber, letterSpacing: 1.0, fontSize: 12),
                                ),
                                Text(
                                  'Reveal your exclusive fashion coupon cashback',
                                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 10),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogCtx);
                    },
                    child: const Text('CLOSE'),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AURA WALLET'),
      ),
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is WalletLoadedState && state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.successMessage!),
                backgroundColor: AppColors.success,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is WalletLoading || state is WalletInitial) {
            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
          } else if (state is WalletLoadedState) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance Card
                  _buildBalanceCard(state, theme, isDark),
                  const SizedBox(height: 24),

                  // Claim Referral Section
                  _buildReferralClaimCard(theme, isDark),
                  const SizedBox(height: 24),

                  // Scratch Cards Showcase
                  _buildScratchCardShowcase(theme, isDark),
                  const SizedBox(height: 24),

                  // Transaction Logs
                  Text(
                    'TRANSACTION HISTORY',
                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 12),
                  _buildTransactionList(state.transactions, theme, isDark),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Failed to load wallet details.'));
          }
        },
      ),
    );
  }

  Widget _buildBalanceCard(WalletLoadedState state, ThemeData theme, bool isDark) {
    final goldColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.black,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: goldColor, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL CASHBACK BALANCE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.6),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '₹${state.cashbackBalance.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'REWARDS POINTS',
                    style: TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.stars, color: goldColor, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '${state.rewardsPoints.toStringAsFixed(0)} pts',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'REFERRAL CREDITS',
                    style: TextStyle(fontSize: 9, color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₹${state.referralCredits.toStringAsFixed(0)}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildReferralClaimCard(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CLAIM REFERRAL REWARD',
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.0),
          ),
          const SizedBox(height: 4),
          Text(
            'Claim ₹50 credits instantly. Enter RAMAN50 to test.',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _referralController,
                  decoration: const InputDecoration(
                    hintText: 'Enter referral code',
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () => _claimReferral(context),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('CLAIM'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildScratchCardShowcase(ThemeData theme, bool isDark) {
    final goldColor = isDark ? AppColors.darkAccent : AppColors.lightAccent;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1F1C18), const Color(0xFF141414)]
              : [const Color(0xFFFAF6F0), Colors.white],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: goldColor, width: 0.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.card_giftcard, color: Colors.amber, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YOU HAVE 1 UNOPENED CARD',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1.0),
                ),
                const SizedBox(height: 2),
                Text(
                  'Scratch to unlock up to ₹500 cashback credits.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(90, 36),
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            onPressed: () => _showScratchCardDialog(context),
            child: const Text('SCRATCH', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(List<WalletTransaction> txs, ThemeData theme, bool isDark) {
    if (txs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Center(child: Text('No transactions logs found.')),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: txs.length,
      itemBuilder: (context, index) {
        final tx = txs[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx.description,
                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${tx.timestamp.day}/${tx.timestamp.month}/${tx.timestamp.year}  ${tx.timestamp.hour}:${tx.timestamp.minute.toString().padLeft(2, '0')}',
                      style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                    ),
                  ],
                ),
              ),
              Text(
                '${tx.isCredit ? "+" : "-"} ₹${tx.amount.toStringAsFixed(0)}',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: tx.isCredit ? Colors.green : Colors.red,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared_widgets/custom_button.dart';
import '../../../../core/shared_widgets/custom_text_field.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _submitLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(RequestOtpEvent(_phoneController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is OtpSentState) {
          context.push('/otp', extra: state.phone);
        } else if (state is AuthenticatedState) {
          context.go('/');
        } else if (state is UnauthenticatedState && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Spacer(flex: 1),
                            // Editorial Header Vibe
                            Text(
                              'AURA',
                              style: theme.textTheme.displayLarge?.copyWith(
                                letterSpacing: 8,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Premium Fashion & Streetwear',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const Spacer(flex: 2),
                            Text(
                              'Welcome Back',
                              style: theme.textTheme.headlineLarge,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Sign in to explore custom fashion selections, manage order shipments, and claim loyalty cashbacks.',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                            const SizedBox(height: 36),
                            // Phone Input
                            CustomTextField(
                              controller: _phoneController,
                              hintText: 'Enter 10-digit Mobile Number',
                              labelText: 'Mobile Number',
                              keyboardType: TextInputType.phone,
                              prefixIcon: Icons.phone_android_outlined,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Phone number cannot be empty';
                                }
                                if (val.replaceAll(RegExp(r'[^0-9]'), '').length < 10) {
                                  return 'Enter a valid 10-digit number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),
                            // Submit Button
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, state) {
                                return CustomButton(
                                  text: 'Send Verification OTP',
                                  isLoading: state is AuthLoading,
                                  onPressed: () => _submitLogin(context),
                                );
                              },
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(child: Divider(color: theme.dividerColor)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Text(
                                    'OR',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                                Expanded(child: Divider(color: theme.dividerColor)),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Google Login Button
                            CustomButton(
                              text: 'Continue with Google',
                              type: ButtonType.outline,
                              icon: Icons.g_mobiledata,
                              onPressed: () {
                                context.read<AuthBloc>().add(GoogleLoginEvent());
                              },
                            ),
                            const Spacer(flex: 3),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'By logging in, you agree to Aura\'s Terms & Privacy Policy.',
                                style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

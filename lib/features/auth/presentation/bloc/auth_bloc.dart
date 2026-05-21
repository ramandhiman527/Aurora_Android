import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/data/mock_database.dart';

// --- AUTHENTICATION EVENTS ---
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class CheckAuthSession extends AuthEvent {}

class RequestOtpEvent extends AuthEvent {
  final String phone;
  const RequestOtpEvent(this.phone);
  @override
  List<Object?> get props => [phone];
}

class VerifyOtpEvent extends AuthEvent {
  final String phone;
  final String otp;
  const VerifyOtpEvent(this.phone, this.otp);
  @override
  List<Object?> get props => [phone, otp];
}

class GoogleLoginEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

// --- AUTHENTICATION STATES ---
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSentState extends AuthState {
  final String phone;
  const OtpSentState(this.phone);
  @override
  List<Object?> get props => [phone];
}

class AuthenticatedState extends AuthState {
  final String phone;
  const AuthenticatedState(this.phone);
  @override
  List<Object?> get props => [phone];
}

class UnauthenticatedState extends AuthState {
  final String? errorMessage;
  const UnauthenticatedState({this.errorMessage});
  @override
  List<Object?> get props => [errorMessage];
}

// --- AUTHENTICATION BLOC ---
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthSession>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(milliseconds: 600));
      if (MockDatabase.isAuthenticated) {
        emit(AuthenticatedState(MockDatabase.userPhone));
      } else {
        emit(const UnauthenticatedState());
      }
    });

    on<RequestOtpEvent>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(milliseconds: 1000));
      if (event.phone.length < 10) {
        emit(const UnauthenticatedState(errorMessage: 'Please enter a valid 10-digit phone number.'));
      } else {
        emit(OtpSentState(event.phone));
      }
    });

    on<VerifyOtpEvent>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(milliseconds: 1200));
      if (event.otp == '1234' || event.otp == '123456' || event.otp.length == 4) {
        MockDatabase.isAuthenticated = true;
        MockDatabase.userPhone = event.phone;
        emit(AuthenticatedState(event.phone));
      } else {
        emit(const UnauthenticatedState(errorMessage: 'Invalid OTP. Please enter 1234 to log in.'));
      }
    });

    on<GoogleLoginEvent>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(milliseconds: 1500));
      MockDatabase.isAuthenticated = true;
      MockDatabase.userPhone = 'bhawanachandel@gmail.com';
      emit(const AuthenticatedState('bhawanachandel@gmail.com'));
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(const Duration(milliseconds: 500));
      MockDatabase.isAuthenticated = false;
      MockDatabase.userPhone = '';
      MockDatabase.cart.clear(); // Clear local active cart on log out
      emit(const UnauthenticatedState());
    });
  }
}

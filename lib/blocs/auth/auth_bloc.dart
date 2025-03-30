import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  const SignInRequested(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class SignOutRequested extends AuthEvent {}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String userId;

  const Authenticated(this.userId);

  @override
  List<Object> get props => [userId];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SignInRequested>(_signInHandler);
    on<SignOutRequested>(_signOutHandler);
  }

  Future<void> _signInHandler(
      SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      // For demonstration, just check if email and password are not empty
      // In a real app, you'd connect to a backend or Firebase
      await Future.delayed(const Duration(seconds: 2));

      if (event.email.isNotEmpty && event.password.isNotEmpty) {
        // Fake authentication success
        emit(Authenticated("user_123"));
      } else {
        emit(const AuthError("Invalid email or password"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _signOutHandler(
      SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      emit(AuthInitial());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}

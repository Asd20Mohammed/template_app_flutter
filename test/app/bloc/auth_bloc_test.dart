// Verifies authentication bloc behaviour using a fake repository.
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_app/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:template_app/src/features/auth/domain/usecases/auth_usecases.dart';
import 'package:template_app/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:template_app/src/features/profile/domain/entities/user.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository();

  User? _user;

  @override
  Future<User> login({required String email, required String password}) async {
    _user = User(
      id: '1',
      email: email,
      displayName: 'Test User',
      roles: const [],
    );
    return _user!;
  }

  @override
  Future<User> register({required String email, required String password}) {
    return login(email: email, password: password);
  }

  @override
  Future<void> logout() async {
    _user = null;
  }

  @override
  Future<User?> getCurrentUser() async => _user;
}

void main() {
  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits authenticated state on login',
      build: () {
        final repository = _FakeAuthRepository();
        return AuthBloc(
          loginUseCase: LoginUseCase(repository),
          registerUseCase: RegisterUseCase(repository),
          logoutUseCase: LogoutUseCase(repository),
          getCurrentUserUseCase: GetCurrentUserUseCase(repository),
        );
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested(email: 'test@test.com', password: 'pass1234'),
      ),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        isA<AuthState>().having(
          (state) => state.status,
          'status',
          AuthStatus.authenticated,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits unauthenticated on logout',
      build: () {
        final repository = _FakeAuthRepository();
        return AuthBloc(
          loginUseCase: LoginUseCase(repository),
          registerUseCase: RegisterUseCase(repository),
          logoutUseCase: LogoutUseCase(repository),
          getCurrentUserUseCase: GetCurrentUserUseCase(repository),
        );
      },
      act: (bloc) async {
        bloc.add(
          const AuthLoginRequested(
            email: 'user@test.com',
            password: 'pass1234',
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 10));
        bloc.add(const AuthLogoutRequested());
      },
      wait: const Duration(milliseconds: 20),
      expect: () => [
        const AuthState(status: AuthStatus.loading),
        isA<AuthState>().having(
          (state) => state.status,
          'status',
          AuthStatus.authenticated,
        ),
        isA<AuthState>().having(
          (state) => state.status,
          'status',
          AuthStatus.unauthenticated,
        ),
      ],
    );
  });
}

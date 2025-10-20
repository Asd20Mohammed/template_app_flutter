// Provides authentication forms for signing in and registering.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:template_app/src/app/router/app_router.dart';
import 'package:template_app/src/core/utils/validators.dart';
import 'package:template_app/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:template_app/src/features/profile/presentation/bloc/user_bloc.dart';
import 'package:template_app/src/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:template_app/src/shared/forms/bloc/template_form_bloc.dart';
import 'package:template_app/src/shared/widgets/buttons/primary_button.dart';
import 'package:template_app/src/shared/widgets/forms/app_text_field.dart';

/// Authentication screen with login and registration forms.
class LoginPage extends StatefulWidget {
  /// Creates a new [LoginPage].
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            context.read<UserBloc>().add(const UserProfileRequested());
            final locale = context.read<SettingsBloc>().state.localeCode;
            HomeRoute(locale: locale).go(context);
          } else if (state.status == AuthStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: BlocBuilder<TemplateFormBloc, TemplateFormState>(
                builder: (context, formState) {
                  return Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Welcome back',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          label: 'Email',
                          controller: _emailController,
                          validator: Validators.validateEmail,
                        ),
                        AppTextField(
                          label: 'Password',
                          controller: _passwordController,
                          validator: Validators.validatePassword,
                          obscureText: true,
                        ),
                        const SizedBox(height: 16),
                        if (formState.status == FormStatus.submitting)
                          const Center(child: CircularProgressIndicator())
                        else
                          PrimaryButton(
                            label: 'Login',
                            onPressed: () => _submit(context, false),
                          ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => _submit(context, true),
                          child: const Text('Create an account'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context, bool isRegister) {
    final formBloc = context.read<TemplateFormBloc>();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    formBloc.add(
      FormSubmitted({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );
    if (isRegister) {
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    } else {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }
}

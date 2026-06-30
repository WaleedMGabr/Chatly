import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/utils/constants.dart';
import 'package:chat_app/core/utils/helpers.dart';
import 'package:chat_app/presentation/widgets/custom_text_field.dart';
import 'package:chat_app/presentation/cubits/auth/auth_cubit.dart';
import 'package:chat_app/presentation/cubits/theme/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureTxt = true;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          showSnackMsg(context, "Successful login");
          Navigator.pushReplacementNamed(context, AppRoutes.main);
        } else if (state is AuthFailed) {
          showSnackMsg(context, state.message);
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: state is AuthLoading,
          child: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 20.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurfaceElevated
                                : AppColors.lightInputFill,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: themeCubit.toggleMode,
                            icon: Icon(
                              isDark
                                  ? Icons.light_mode_rounded
                                  : Icons.dark_mode_rounded,
                              color: isDark
                                  ? AppColors.darkPrimary
                                  : AppColors.lightPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (isDark
                                      ? AppColors.darkPrimary
                                      : AppColors.lightPrimary)
                                  .withOpacity(0.25),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Image.asset("assets/photos/Chatly.png"),
                      ),
                      const SizedBox(height: 16),
                      Text("Welcome Back",
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text("Sign in to continue chatting",
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 40),
                      CustomTextFormField(
                        controller: _email,
                        hintText: "abc@example.com",
                        labelText: "Email",
                        prefixIcon: Icons.email_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _pass,
                        hintText: "••••••••",
                        labelText: "Password",
                        prefixIcon: CupertinoIcons.lock,
                        isPassword: _obscureTxt,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() => _obscureTxt = !_obscureTxt);
                          },
                          icon: Icon(_obscureTxt
                              ? CupertinoIcons.eye
                              : CupertinoIcons.eye_slash),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  if (_formkey.currentState!.validate()) {
                                    context.read<AuthCubit>().login(
                                          _email.text.trim(),
                                          _pass.text,
                                        );
                                  }
                                },
                          child: const Text("Log in"),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?",
                              style: Theme.of(context).textTheme.bodyMedium),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.signup);
                            },
                            child: const Text("Sign up"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

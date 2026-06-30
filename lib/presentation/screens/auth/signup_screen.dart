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

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscureTxt = true;
  bool _confirmPassObscureTxt = true;
  final TextEditingController _username = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _pass.dispose();
    _confirmPass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.read<ThemeCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          showSnackMsg(context, "Sign up successfully");
          Navigator.pushReplacementNamed(context, AppRoutes.login);
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
                      Text("Create Account",
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text("Join Chatly and start chatting",
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 40),
                      CustomTextFormField(
                        controller: _username,
                        hintText: "username",
                        labelText: "Username",
                        prefixIcon: Icons.person_outline_sharp,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _email,
                        hintText: "abc@example.com",
                        labelText: "Email",
                        prefixIcon: Icons.email_outlined,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          final emailRegex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+com$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Email should be like abc@example.com';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _pass,
                        hintText: "********",
                        labelText: "Password",
                        prefixIcon: CupertinoIcons.lock,
                        isPassword: _obscureTxt,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          final passRegex = RegExp(
                            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$',
                          );
                          if (!passRegex.hasMatch(value)) {
                            return "+8 chars with at least 1 small, capital, number, and special character";
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
                      const SizedBox(height: 20),
                      CustomTextFormField(
                        controller: _confirmPass,
                        hintText: "********",
                        labelText: "Confirm Password",
                        prefixIcon: CupertinoIcons.lock,
                        isPassword: _confirmPassObscureTxt,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (_pass.text != _confirmPass.text) {
                            return 'Password does not match';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() => _confirmPassObscureTxt =
                                !_confirmPassObscureTxt);
                          },
                          icon: Icon(_confirmPassObscureTxt
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
                                    context.read<AuthCubit>().signup(
                                          _email.text.trim(),
                                          _pass.text,
                                          _username.text.trim(),
                                        );
                                  } else {
                                    showSnackMsg(
                                        context, "Please fix the errors");
                                  }
                                },
                          child: const Text("Sign up"),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?",
                              style: Theme.of(context).textTheme.bodyMedium),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, AppRoutes.login);
                            },
                            child: const Text("Login"),
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

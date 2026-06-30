import 'dart:convert';

import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/core/utils/constants.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/usecases/auth/logout_use_case.dart';
import 'package:chat_app/presentation/cubits/profile/profile_cubit.dart';
import 'package:chat_app/presentation/cubits/theme/theme_cubit.dart';
import 'package:chat_app/presentation/widgets/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  final LogoutUseCase logoutUseCase;

  const ProfileScreen({super.key, required this.logoutUseCase});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? _pendingPhotoBase64;
  bool _isInitialized = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _pendingPhotoBase64 = base64Encode(bytes);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeCubit = context.read<ThemeCubit>();

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          if (!_isInitialized) {
            _nameController.text = state.user.name;
            _isInitialized = true;
          }
        }
      },
      builder: (context, state) {
        UserEntity? user;
        if (state is ProfileLoaded) {
          user = state.user;
        }
        final isUpdating = state is ProfileUpdating;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              ProfileAvatar(
                user: user,
                pendingPhotoBase64: _pendingPhotoBase64,
                isDark: isDark,
                isUpdating: isUpdating,
                onPickPhoto: _pickPhoto,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _nameController,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: const InputDecoration(labelText: 'Display Name', prefixIcon: Icon(Icons.person_outline)),
              ),

              const SizedBox(height: 16),
              TextField(
                enabled: false,
                controller: TextEditingController(text: user?.email ?? ''),
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
              ),
              const SizedBox(height: 32),
              Material(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: isDark ? AppColors.darkDivider : AppColors.lightDivider, width: 0.5),
                ),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: Icon(isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded, color: isDark ? AppColors.darkPrimary : AppColors.lightPrimary),
                  title: Text('Dark Mode', style: Theme.of(context).textTheme.labelLarge),
                  trailing: Switch(value: isDark, activeTrackColor: AppColors.darkPrimary, onChanged: (_) => themeCubit.toggleMode()),
                ),
              ),
              const SizedBox(height: 16),
              Material(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: BorderSide(color: isDark ? AppColors.darkDivider : AppColors.lightDivider, width: 0.5),
                ),
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  leading: Container(width: 10, height: 10, decoration: BoxDecoration(color: (user?.isOnline ?? false) ? AppColors.online : AppColors.error, shape: BoxShape.circle)),
                  title: Text('Status', style: Theme.of(context).textTheme.labelLarge),
                  trailing: Text((user?.isOnline ?? false) ? 'Online' : 'Offline', style: Theme.of(context).textTheme.bodyMedium),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isUpdating ? null : () {
                    final currentName = user?.name ?? '';
                    final newName = _nameController.text.trim();
                    final nameToSave = (newName.isNotEmpty && newName != currentName) ? newName : null;

                    if (nameToSave != null || _pendingPhotoBase64 != null) {
                      context.read<ProfileCubit>().saveEdits(
                        newName: nameToSave,
                        newPhotoBase64: _pendingPhotoBase64,
                      );
                      setState(() {
                        _pendingPhotoBase64 = null;
                      });
                    }
                  },
                  icon: const Icon(Icons.save_rounded),
                  label: const Text('Save Edits'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? AppColors.darkPrimary : AppColors.lightPrimary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await widget.logoutUseCase();
                    if (context.mounted) {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    }
                  },
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Log out'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}

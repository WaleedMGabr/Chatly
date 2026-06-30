import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/presentation/cubits/users/users_cubit.dart';
import 'package:chat_app/presentation/widgets/search_bar_widget.dart';
import 'package:chat_app/presentation/widgets/user_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentUid = FirebaseAuth.instance.currentUser!.uid;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        AppSearchBar(
          hintText: 'Search people...',
          onChanged: (query) {
            context.read<UsersCubit>().searchUsers(query);
          },
        ),
        Expanded(
          child: BlocBuilder<UsersCubit, UsersState>(
            builder: (context, state) {
              if (state is UsersLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is UsersError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
                      const SizedBox(height: 12),
                      Text(state.message, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                    ],
                  ),
                );
              }
              if (state is UsersLoaded) {
                final users = state.users;
                if (users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline_rounded, size: 64, color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint),
                        const SizedBox(height: 16),
                        Text("No users found", style: Theme.of(context).textTheme.bodyLarge),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return UserTile(user: users[index], currentUid: currentUid, isDark: isDark);
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}

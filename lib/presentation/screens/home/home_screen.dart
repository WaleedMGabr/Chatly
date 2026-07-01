// Home screen showing the current user's recent chats with search filtering.
// Uses UserChatCubit to display a real-time list of ChatTile widgets and
// AppSearchBar for client-side search by name or message content.

import 'package:chat_app/core/theme/app_colors.dart';
import 'package:chat_app/presentation/cubits/user_chat/user_chat_cubit.dart';
import 'package:chat_app/presentation/widgets/chat_tile.dart';
import 'package:chat_app/presentation/widgets/search_bar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentUid = FirebaseAuth.instance.currentUser!.uid;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSearchBar(
          hintText: 'Search chats...',
          onChanged: (query) {
            context.read<UserChatCubit>().searchChats(query);
          },
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Text(
            "Recent Chats",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: BlocBuilder<UserChatCubit, UserChatState>(
            builder: (context, state) {
              if (state is UserChatLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is UserChatError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
                      const SizedBox(height: 12),
                      Text(state.errorMsg, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                    ],
                  ),
                );
              }
              if (state is UserChatLoaded) {
                final chats = state.chats;
                if (chats.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.forum_outlined, size: 64, color: isDark ? AppColors.darkTextHint : AppColors.lightTextHint),
                        const SizedBox(height: 16),
                        Text("No chats yet", style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 4),
                        Text("Go to People tab to start a conversation", style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final String formatted = chat.lastMessageTime != null ? DateFormat('HH:mm').format(chat.lastMessageTime!) : '';
                    return ChatTile(otherUid: chat.otherUid, otherName: chat.otherName, lastMessage: chat.lastMessage, time: formatted, currentUid: currentUid, isDark: isDark);
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

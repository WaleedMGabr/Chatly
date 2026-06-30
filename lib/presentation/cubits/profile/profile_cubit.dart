import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chat_app/domain/entities/user_entity.dart';
import 'package:chat_app/domain/usecases/profile/get_profile_use_case.dart';
import 'package:chat_app/domain/usecases/profile/update_name_use_case.dart';
import 'package:chat_app/domain/usecases/profile/update_photo_use_case.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateNameUseCase updateNameUseCase;
  final UpdatePhotoUseCase updatePhotoUseCase;
  StreamSubscription? _subscription;

  ProfileCubit({
    required this.getProfileUseCase,
    required this.updateNameUseCase,
    required this.updatePhotoUseCase,
  }) : super(ProfileInitial());

  void loadProfile() {
    emit(ProfileLoading());
    try {
      _subscription?.cancel();
      _subscription = getProfileUseCase().listen(
        (user) {
          emit(ProfileLoaded(user: user));
        },
        onError: (e) {
          emit(ProfileError(message: e.toString()));
        },
      );
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  Future<void> saveEdits({String? newName, String? newPhotoBase64}) async {
    try {
      emit(ProfileUpdating());
      if (newName != null) {
        await updateNameUseCase(newName);
      }
      if (newPhotoBase64 != null) {
        await updatePhotoUseCase(newPhotoBase64);
      }
    } catch (e) {
      emit(ProfileError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

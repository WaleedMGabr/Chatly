import 'package:chat_app/domain/entities/user_entity.dart';

abstract class ProfileRepository {
  Stream<UserEntity> getProfile();
  Future<void> updateName(String name);
  Future<void> updatePhoto(String base64Image);
}

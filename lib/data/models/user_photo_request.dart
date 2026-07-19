/// Тело запроса загрузки фото пользователя (`POST /user/photo`).
class UserPhotoRequest {
  const UserPhotoRequest({this.avatar});

  final String? avatar;

  Map<String, dynamic> toJson() => {'avatar': avatar};
}

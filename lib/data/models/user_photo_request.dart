import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_photo_request.freezed.dart';
part 'user_photo_request.g.dart';

/// Тело запроса загрузки фото пользователя (`POST /user/photo`).
@freezed
abstract class UserPhotoRequest with _$UserPhotoRequest {
  const factory UserPhotoRequest({
    String? avatar,
  }) = _UserPhotoRequest;

  factory UserPhotoRequest.fromJson(Map<String, dynamic> json) =>
      _$UserPhotoRequestFromJson(json);
}

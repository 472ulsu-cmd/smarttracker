import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_response.freezed.dart';
part 'user_response.g.dart';

/// Ответ `GET /user` (профиль водителя).
@freezed
class UserResponse with _$UserResponse {
  const factory UserResponse({
    int? id,
    String? login,
    String? name,
    @JsonKey(name: 'second_name') String? secondName,
    String? surname,
    String? phone,
    @JsonKey(name: 'phone_code') int? phoneCode,
    String? avatar,
  }) = _UserResponse;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}

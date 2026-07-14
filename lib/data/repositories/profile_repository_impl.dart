import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../../domain/models/app_exception.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/user_photo_request.dart' as api;
import '../models/user_request.dart' as api;
import '../models/user_response.dart' as api;

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<User> fetchProfile() async {
    try {
      final response = await _dio.get<dynamic>('/user');
      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};
      return _toDomain(api.UserResponse.fromJson(data));
    } on DioException catch (e) {
      throw _rethrowDio(e);
    }
  }

  @override
  Future<User> updateProfile({
    String? login,
    String? name,
    String? secondName,
    String? surname,
    String? phone,
    int? phoneCode,
  }) async {
    try {
      await _dio.post<dynamic>(
        '/user',
        data: api.UserRequest(
          login: login,
          name: name,
          secondName: secondName,
          surname: surname,
          phone: phone,
          phoneCode: phoneCode,
        ),
      );
      // После обновления повторно запрашиваем актуальный профиль.
      return fetchProfile();
    } on DioException catch (e) {
      throw _rethrowDio(e);
    }
  }

  @override
  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await _dio.post<dynamic>(
        '/user/password',
        data: api.UserPasswordRequest(
          oldPassword: oldPassword,
          password: newPassword,
        ),
      );
    } on DioException catch (e) {
      throw _rethrowDio(e);
    }
  }

  @override
  Future<void> uploadAvatar(String filePath) async {
    try {
      final bytes = await File(filePath).readAsBytes();
      final base64Str = base64Encode(bytes);
      await _dio.post<dynamic>(
        '/user/photo',
        data: api.UserPhotoRequest(avatar: base64Str),
      );
    } on DioException catch (e) {
      throw _rethrowDio(e);
    }
  }

  User _toDomain(api.UserResponse u) {
    return User(
      id: u.id ?? 0,
      login: u.login ?? '',
      name: u.name ?? '',
      secondName: u.secondName ?? '',
      surname: u.surname ?? '',
      phone: u.phone ?? '',
      phoneCode: u.phoneCode ?? 1,
      avatar: u.avatar ?? '',
    );
  }

  Never _rethrowDio(DioException e) {
    final cause = e.error;
    if (cause is AppException) throw cause;
    throw const NetworkException();
  }
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../domain/models/app_exception.dart';
import '../../domain/repositories/photo_repository.dart';
import '../models/photo_responses.dart' as api;

class PhotoRepositoryImpl implements PhotoRepository {
  PhotoRepositoryImpl({required Dio dio, ImagePicker? picker})
      : _dio = dio,
        _picker = picker ?? ImagePicker();

  final Dio _dio;
  final ImagePicker _picker;

  @override
  Future<int> uploadPhotoByType(
      int orderId, int routePhotoTypeId, String filePath) async {
    try {
      final form = FormData.fromMap({
        'photo': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.post<dynamic>(
        '/orders/$orderId/photo_type/$routePhotoTypeId/photo',
        data: form,
      );
      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};
      final parsed = api.OrdersRoutePhotoTypeResponse.fromJson(data);
      return parsed.photoId ?? 0;
    } on DioException catch (e) {
      throw _rethrowDio(e);
    }
  }

  @override
  Future<String> uploadPhoto(
      int orderId, int routePhotoId, String filePath) async {
    try {
      final form = FormData.fromMap({
        'photo': await MultipartFile.fromFile(filePath),
      });
      final response = await _dio.post<dynamic>(
        '/orders/$orderId/photo/$routePhotoId',
        data: form,
      );
      final data = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : <String, dynamic>{};
      final parsed = api.OrdersRoutePhotoResponse.fromJson(data);
      return parsed.url ?? '';
    } on DioException catch (e) {
      throw _rethrowDio(e);
    }
  }

  @override
  Future<String?> pickImage(ImageSourceOption source) async {
    try {
      final xFile = await _picker.pickImage(
        source: source == ImageSourceOption.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        imageQuality: 80,
      );
      if (xFile == null) return null;

      // Копируем в ApplicationDocuments/photos — стабильный путь.
      final appDir = await getApplicationDocumentsDirectory();
      final photosDir = Directory(p.join(appDir.path, 'photos'));
      if (!await photosDir.exists()) {
        await photosDir.create(recursive: true);
      }
      final ext = p.extension(xFile.path);
      final dest = p.join(
        photosDir.path,
        'photo_${DateTime.now().millisecondsSinceEpoch}$ext',
      );
      await File(xFile.path).copy(dest);
      return dest;
    } catch (_) {
      throw const UnknownException('Не удалось получить изображение.');
    }
  }

  Never _rethrowDio(DioException e) {
    final cause = e.error;
    if (cause is AppException) throw cause;
    throw const NetworkException();
  }
}

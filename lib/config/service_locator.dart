import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/feedback_repository_impl.dart';
import '../data/repositories/mock_auth_repository.dart';
import '../data/repositories/mock_repositories.dart';
import '../data/repositories/notifications_repository_impl.dart';
import '../data/repositories/orders_repository_impl.dart';
import '../data/repositories/photo_repository_impl.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../data/repositories/sync_repository_impl.dart';
import '../data/services/dio_provider.dart';
import '../data/services/local_photo_store.dart';
import '../data/services/secure_storage_service.dart';
import '../data/services/settings_service.dart';
import '../data/services/sync_config_service.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/feedback_repository.dart';
import '../domain/repositories/notifications_repository.dart';
import '../domain/repositories/orders_repository.dart';
import '../domain/repositories/photo_repository.dart';
import '../domain/repositories/profile_repository.dart';
import '../domain/repositories/sync_repository.dart';
import '../ui/features/auth/view_models/auth_view_model.dart';
import '../ui/features/location/view_models/location_permission_view_model.dart';
import '../ui/features/notifications/view_models/notifications_view_model.dart';
import '../ui/features/notifications/view_models/unread_badge_view_model.dart';
import '../ui/features/orders/view_models/orders_view_model.dart';
import '../ui/features/profile/view_models/profile_view_model.dart';
import 'app_config.dart';
import 'refresh_bus.dart';

/// Глобальный контейнер зависимостей.
final GetIt getIt = GetIt.instance;

/// Регистрирует все зависимости в [getIt].
///
/// Если [config.useMock] == true, репозитории заменяются mock-реализациями,
/// позволяя работать без backend.
Future<void> setupDependencies(AppConfig config) async {
  // --- Config ---
  if (!getIt.isRegistered<AppConfig>()) {
    getIt.registerSingleton<AppConfig>(config);
  }

  // --- Storage ---
  if (!getIt.isRegistered<SecureStorageService>()) {
    getIt.registerLazySingleton<SecureStorageService>(
      SecureStorageService.new,
    );
  }
  if (!getIt.isRegistered<LocalPhotoStore>()) {
    getIt.registerSingleton<LocalPhotoStore>(LocalPhotoStore.instance);
    await getIt<LocalPhotoStore>().init();
  }

  // --- Dio ---
  if (!getIt.isRegistered<Dio>()) {
    getIt.registerLazySingleton<Dio>(
      () => DioProvider.create(
        config: getIt<AppConfig>(),
        storage: getIt<SecureStorageService>(),
      ),
    );
  }

  // --- Repositories ---
  if (!getIt.isRegistered<AuthRepository>()) {
    if (config.useMock) {
      getIt.registerLazySingleton<AuthRepository>(MockAuthRepository.new);
    } else {
      getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
          dio: getIt<Dio>(),
          storage: getIt<SecureStorageService>(),
        ),
      );
    }
  }

  if (!getIt.isRegistered<OrdersRepository>()) {
    getIt.registerLazySingleton<OrdersRepository>(
      config.useMock
          ? MockOrdersRepository.new
          : () => OrdersRepositoryImpl(dio: getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<PhotoRepository>()) {
    getIt.registerLazySingleton<PhotoRepository>(
      config.useMock
          ? MockPhotoRepository.new
          : () => PhotoRepositoryImpl(
              dio: getIt<Dio>(),
              picker: ImagePicker(),
            ),
    );
  }

  if (!getIt.isRegistered<NotificationsRepository>()) {
    getIt.registerLazySingleton<NotificationsRepository>(
      config.useMock
          ? MockNotificationsRepository.new
          : () => NotificationsRepositoryImpl(dio: getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<ProfileRepository>()) {
    getIt.registerLazySingleton<ProfileRepository>(
      config.useMock
          ? MockProfileRepository.new
          : () => ProfileRepositoryImpl(dio: getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<SyncRepository>()) {
    getIt.registerLazySingleton<SyncRepository>(
      config.useMock
          ? MockSyncRepository.new
          : () => SyncRepositoryImpl(dio: getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<FeedbackRepository>()) {
    getIt.registerLazySingleton<FeedbackRepository>(
      config.useMock
          ? MockFeedbackRepository.new
          : () => FeedbackRepositoryImpl(dio: getIt<Dio>()),
    );
  }

  // --- Settings (локальный переключатель push) ---
  if (!getIt.isRegistered<SettingsService>()) {
    getIt.registerLazySingleton<SettingsService>(SettingsService.new);
    await getIt<SettingsService>().init();
  }

  // --- SyncConfig (локальная конфигурация периодов синхронизации) ---
  if (!getIt.isRegistered<SyncConfigService>()) {
    getIt.registerLazySingleton<SyncConfigService>(SyncConfigService.new);
  }
  await getIt<SyncConfigService>().init();

  // --- Шины обновления списков (singleton) ---
  if (!getIt.isRegistered<OrdersRefreshBus>()) {
    getIt.registerLazySingleton<OrdersRefreshBus>(OrdersRefreshBus.new);
  }
  if (!getIt.isRegistered<NotificationsRefreshBus>()) {
    getIt.registerLazySingleton<NotificationsRefreshBus>(
        NotificationsRefreshBus.new);
  }

  // Носитель pending deep-link: тап по пушу → открыть заявку.
  if (!getIt.isRegistered<DeepLinkBus>()) {
    getIt.registerLazySingleton<DeepLinkBus>(DeepLinkBus.new);
  }

  // --- ViewModels ---
  // AuthViewModel — singleton: единое состояние сессии для всего приложения
  // (роутер, MainShell, экраны входа/профиля слушают один экземпляр).
  if (!getIt.isRegistered<AuthViewModel>()) {
    getIt.registerLazySingleton<AuthViewModel>(
      () => AuthViewModel(
        getIt<AuthRepository>(),
        getIt<SyncRepository>(),
        getIt<SyncConfigService>(),
      ),
    );
  }

  // LocationPermissionViewModel — singleton: статус разрешения геолокации
  // для всего приложения (роутер, экран запроса, фоновые сервисы).
  if (!getIt.isRegistered<LocationPermissionViewModel>()) {
    getIt.registerLazySingleton<LocationPermissionViewModel>(
      LocationPermissionViewModel.new,
    );
  }

  // Singleton: общий счётчик для бейджа нижней навигации.
  if (!getIt.isRegistered<UnreadBadgeViewModel>()) {
    getIt.registerLazySingleton<UnreadBadgeViewModel>(
      () => UnreadBadgeViewModel(getIt<NotificationsRepository>()),
    );
  }
  getIt.registerFactory<OrdersViewModel>(
    () => OrdersViewModel(getIt<OrdersRepository>()),
  );
  // ProfileViewModel — singleton: профиль водителя — разделяемое состояние.
  // Экраны профиля/редактирования/смены пароля слушают один экземпляр, поэтому
  // после updateProfile()/uploadAvatar() изменения подтягиваются через
  // notifyListeners() без ручной перезагрузки и хаков с результатом pop().
  if (!getIt.isRegistered<ProfileViewModel>()) {
    getIt.registerLazySingleton<ProfileViewModel>(
      () => ProfileViewModel(getIt<ProfileRepository>()),
    );
  }
  // Singleton: список уведомлений предзагружается при входе (см. MainShell),
  // чтобы к моменту открытия вкладки данные были готовы, а бейдж обновился сразу.
  if (!getIt.isRegistered<NotificationsViewModel>()) {
    getIt.registerLazySingleton<NotificationsViewModel>(
      () => NotificationsViewModel(
        getIt<NotificationsRepository>(),
        ordersRepository: getIt<OrdersRepository>(),
      ),
    );
  }
}
